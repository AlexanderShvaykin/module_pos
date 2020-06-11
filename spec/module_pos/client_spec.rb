RSpec.describe ModulePos::Fiscalization::Client do
  let(:host) { "https://demo-fn.avanpos.com/fn" }
  let(:stubs) { Faraday::Adapter::Test::Stubs.new }
  let(:conn) { Faraday.new { |b| b.adapter(:test, stubs) } }
  let(:client) { described_class.new(conn: conn, host: host) }

  describe "Associate" do
    describe "POST associate" do
      subject { client.associate('123').create(params) }

      let(:params) do
        { login: "site_login", secret: "site_password" }
      end
      it 'returns credentials' do
        stubs.post('/api/fn/v1/associate/123') do |env|
          with_path env, "/api/fn/v1/associate/123"
          with_basic_auth env, "site_login", "site_password"
          expect(env.params).to be_empty
          [
            200,
            {},
            '{"userName": "54337d0c-975e-4aeb-be5e-ede5a1b194b6", "password": "ECMvSGCtiDq55lee", "name": "Foo", "address": "Moscow"}'
          ]
        end

        expect(subject)
          .to have_attributes user_name: "54337d0c-975e-4aeb-be5e-ede5a1b194b6",
                              password:  "ECMvSGCtiDq55lee",
                              name:      "Foo",
                              address:   "Moscow"
        stubs.verify_stubbed_calls
      end

      it "raises error if server return error" do
        stubs.post('/api/fn/v1/associate/123') do |env|
          expect(env.params).to be_empty
          [
            400,
            {},
            ""
          ]
        end

        expect { subject }.to raise_exception(ModulePos::Fiscalization::ResponseError)
      end

      describe "associate with client_id" do
        let(:params) do
          super().merge(client_id: "lol")
        end
        it 'returns credentials' do
          stubs.post('/api/fn/v1/associate/123') do |env|
            with_basic_auth env, "site_login", "site_password"
            with_path env, "/api/fn/v1/associate/123"
            with_query env, "clientId" => "lol"
            [
              200,
              {},
              '{"userName": "54337d0c-975e-4aeb-be5e-ede5a1b194b6", "password": "ECMvSGCtiDq55lee", "name": "Foo", "address": "Moscow"}'
            ]
          end

          expect(subject)
            .to have_attributes user_name: "54337d0c-975e-4aeb-be5e-ede5a1b194b6",
                                password:  "ECMvSGCtiDq55lee",
                                name:      "Foo",
                                address:   "Moscow"
          stubs.verify_stubbed_calls
        end
      end
    end

    describe "DELETE associate" do
      it 'sends delete request' do
        stubs.delete('/api/fn/v1/associate/123') do |env|
          # optional: you can inspect the Faraday::Env
          with_path env, "/api/fn/v1/associate/123"
          with_basic_auth env, "name", "pass"
          [
            200,
            {},
            ""
          ]
        end

        client.associate('123').delete(username: "name", password: "pass")
        stubs.verify_stubbed_calls
      end
    end
  end

  context "with credentials" do
    let(:pass) { "pass" }
    let(:name) { "name" }
    let(:client) { described_class.new(conn: conn, host: host, username: name, pass: pass) }

    describe "GET status" do
      let(:path) { "/api/fn/v1/status" }
      it 'sends get request' do
        stubs.get(path) do |env|
          with_path env, path
          with_basic_auth env, name, pass
          [
            200,
            {},
            '{"status": "READY","dateTime": "2019-09-17T03:31:56+00:00"}'
          ]
        end

        expect(client.status)
          .to have_attributes(
                status: "READY", date_time: "2019-09-17T03:31:56+00:00", ready?: true
              )
        stubs.verify_stubbed_calls
      end
    end

    describe "POST docs.send" do
      let(:path) { "/api/fn/v2/doc" }
      let(:doc) do
        ModulePos::Fiscalization::Entities::Doc.new(
          doc_num:            "Order-1",
          id:                 "dda2911b-5681-4a02-bd3d-3f0d0df849da",
          doc_type:           "SALE",
          checkout_date_time: "2019-08-16T15:45:17+07:00",
          email:              "example@example.com",
          print_receipt:      false,
          text_to_print:      nil,
          responseURL:        "https://internet.shop.ru/order/982340931/checkout?completed=1",
          tax_mode:           "COMMON",
          agent_info:         nil,
          invent_positions:   [
                                {
                                  barcode:        "10001",
                                  name:           "Молоко Лебедевское, 2,5%",
                                  price:          52,
                                  discSum:        "5.2",
                                  quantity:       1,
                                  vatTag:         1102,
                                  payment_object: "commodity",
                                  payment_method: "full_payment",
                                }
                              ],
          moneyPositions:     [{ paymentType: "CARD", sum: "46.8" }]
        )
      end

      it 'sends request and return doc status' do
        stubs.post(path) do |env|
          with_path env, path
          with_basic_auth env, name, pass
          with_body env, doc.to_json
          [
            200,
            {},
            File.read("spec/fixtures/doc_response.json")
          ]
        end

        # see spec/fixtures/doc_response.json
        expect(client.docs.save(doc))
          .to have_attributes(
                status: "QUEUED", fn_state: "READY", message: "Document queued for printing",
                time_status_changed: "2019-09-16T14:01:08+00:00"
              )
        stubs.verify_stubbed_calls
      end
    end

    describe "GET docs.status" do
      let(:path) { "/api/fn/v1/doc/#{id}/status" }
      let(:id) { "q24" }

      it 'sends request and return doc status' do
        stubs.get(path) do |env|
          with_path env, path
          with_basic_auth env, name, pass
          [
            200,
            {},
            File.read("spec/fixtures/doc_status.json")
          ]
        end

        result = client.docs.status(id)
        expect(result)
          .to have_attributes(
                status: "COMPLETED", fn_state: "READY",
                message: "Document successfully completed with callback",
              )
        expect(result.fiscal_info)
          .to have_attributes(
                shift_number: 8, kkt_number: "199036005916"
              )

        stubs.verify_stubbed_calls
      end
    end

    describe "GET docs.re_queue" do
      let(:path) { "/api/fn/v1/doc/#{id}/re-queue" }
      let(:id) { "q24" }

      it 'sends request and return doc status' do
        stubs.put(path) do |env|
          with_path env, path
          with_basic_auth env, name, pass
          [
            200,
            {},
            File.read("spec/fixtures/doc_response.json")
          ]
        end

        expect(client.docs.re_queue(id))
          .to have_attributes(
                status: "QUEUED", fn_state: "READY", message: "Document queued for printing",
                time_status_changed: "2019-09-16T14:01:08+00:00"
              )

        stubs.verify_stubbed_calls
      end
    end
  end

  def with_basic_auth(env, name, pass)
    expect(env.request_headers['Authorization'])
      .to eq("Basic #{Base64.encode64("#{name}:#{pass}").chomp}")
  end

  def with_path(env, url)
    expect(env.url.path).to eq(url)
  end

  def with_query(env, params)
    expect(env.params).to eq(params)
  end

  def with_body(env, body)
    expect(env.body).to eq(body)
  end
end
