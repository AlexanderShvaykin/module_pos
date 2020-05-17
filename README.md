![Ruby](https://github.com/AlexanderShvaykin/module_pos/workflows/Ruby/badge.svg)

# ModulePos::Fiscalization
Simple lib, wrapped https://modulkassa.ru API for fiscalization online receipts
version API v1.4

## Installation

Add this line to your application's Gemfile:

```ruby
gem ' module_pos-fiscalization'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install  module_pos-fiscalization

## Usage

```ruby
receipt = Order.find("some_id").receipt
host = "https://modulepos.test.server"
secrets = ModulePos::Fiscalization::Client.new(host: host).associate('you_uid').create
user_name = secrets.user_name
pass = secrets.password
ModulePos::Fiscalization::Client.new(host: host, username: user_name, pass: pass) do |client|
  if client.status.ready?
    doc = ModulePos::Fiscalization::Doc.create(
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

    client.docs.save(doc)
    client.docs.re_queue(doc.id) if client.docs.status(doc.id).failed?
    until client.docs.status(doc.id).success? # may be background job
    end
    receipt.update(fiscal_info: client.docs.status(doc.id).as_json) 
  end
end

```

Full available fields you find in documentation v1.4 ModuleBank POS Api, you can use snake_case and camelCase

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/modul-pos. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/modul-pos/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Modul::Pos project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/modul-pos/blob/master/CODE_OF_CONDUCT.md).
