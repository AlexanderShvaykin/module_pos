RSpec.describe ModulePos::Fiscalization::Doc do
  describe ".create" do
    let(:params) do
      {
        doc_num:            "Order-1",
        id:                 "dda2911b-5681-4a02-bd3d-3f0d0df849da",
        doc_type:           "SALE",
        checkout_date_time: "2019-08-16T15:45:17+07:00",
        email:              "example@example.com",
        print_receipt:      false,
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
      }
    end

    it "returns Entities::Doc" do
      expect(described_class.create(params)).to be_a(ModulePos::Fiscalization::Entities::Doc)
    end
  end
end
