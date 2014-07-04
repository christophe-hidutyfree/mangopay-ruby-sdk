[ ![Codeship Status for christophe-hidutyfree/mangopay-ruby-sdk](https://codeship.io/projects/ce1d6490-e5a3-0131-6d1f-46277ec996ce/status)](https://codeship.io/projects/25775)
# MangoPay Ruby SDK

The gem for interacting with MangoPay API.
See the [API documentation](http://www.mangopay.com/api-references/) for more details on the API.

Tested on the following versions of Ruby: 1.9.2, 1.9.3, 2.0.0

## Code Status
[![Build Status](https://travis-ci.org/Leetchi/mangopay.png?branch=master)](https://travis-ci.org/Leetchi/mangopay)
[![Code Climate](https://codeclimate.com/github/MangoPay/mangopay-ruby-sdk.png)](https://codeclimate.com/github/MangoPay/mangopay-ruby-sdk)
[![Dependency Status](https://gemnasium.com/MangoPay/mangopay-ruby-sdk.png)](https://gemnasium.com/MangoPay/mangopay-ruby-sdk)

## NEWS

### Version 2.0.0
** BREAKING CHANGES **
The Gem has been updated to 2.0.0
It has been renamed from leetchi-api-ruby-sdk to mangopay.

Please make sure you update all the internal calls from Leetchi to MangoPay.

## Requirements

This gem uses mainly ruby stdlib and the *json* gem.

## Configuration

Please note that the gem configuration process change between 0.0.1 and 1.0.0.

### Version 0.0.1

Setup the following ENV:

```
ENV['LEETCHI_API_BASE_URL'] = "https://api-preprod.leetchi.com" # once you've run your test using the preproduction environment use the production one
ENV['LEETCHI_KEY_PATH'] = "abcd"                                # the full path to your leetchi key
ENV['LEETCHI_PASSPHRASE'] = "efgh"                              # you key's passphrase (leave blank if none)
ENV['LEETCHI_PARTNER_ID'] = "myID"                              # your MangoPay API ID
```

### Version 1.0.0

You can now call the MangoPay.configure method like this:

```ruby
MangoPay.configure do |c|
    c.preproduction = true
    c.partner_id = 'example'
    c.key_path = './spec/support-files/example.pem'
    c.key_password = ''
end
```

The **preproduction** attribute let you specify if you want to use the preproduction api endpoint.

The **partner_id** is the id that was issue to you during you registration process.

The **key_path** and **key_password** arguments are here to let you use the key you've created before the registration process.

This configure method can of course be use to define a Ruby on Rails initialiser.

## Usage

The gem implements the following resources:
- Beneficiary
- Card
- Contribution
- Expense
- Operation
- Immediate Contribution
- Recurrent Contribution (only available in preproduction)
- Strong Authentication
- Transfer
- User
- Wallet
- Withdrawal

Each resource has specifics methods such has `create`, `details`, `update`, etc. Those methods must be called with an ID and / or an Object matching the MangoPay API.
Calling those methods return the MangoPay API response has an object. Every executions are made synchronously.

### Example

This example creates a user and returns its informations:

```ruby
MangoPay::User.create({
    'Tag' => 'test',
    'Email' => 'my@email.com',
    'FistName' => 'Jack',
    'LastName' => 'Nelson',
    'CanRegisterMeanOfPayment' => true
})
```

This example returns a specific user's data:

```ruby
MangoPay::User.details(123)
```

### Tests
Make sure that you have run: ```bundle install```
Then you just have to run the rake task ```rake test``` to run all the test suite.
Feel free to report any test failure by creating an issue on the [Gem's Github](https://github.com/MangoPay/leetchi-api-ruby-sdk/issues)

## Contributing

Take a look at the [CONTRIBUTING](https://github.com/Leetchi/mangopay/blob/master/CONTRIBUTING.md) file of this repo

1. Fork the repo.

2. Run the tests. We only take pull requests with passing tests, and it's great
to know that you have a clean slate: `bundle && bundle exec rake`

3. Add a test for your change. Only refactoring and documentation changes
require no new tests. If you are adding functionality or fixing a bug, we need
a test!

4. Make the test pass.

5. Push to your fork and submit a pull request.

At this point you're waiting on us. We like to at least comment on, if not
accept, pull requests within three business days (and, typically, one business
day). We may suggest some changes or improvements or alternatives.

Syntax:

* Two spaces, no tabs.
* No trailing whitespace. Blank lines should not have any space.
* Prefer &&/|| over and/or.
* MyClass.my_method(my_arg) not my_method( my_arg ) or my_method my_arg.
* a = b and not a=b.
* Follow the conventions you see used in the source already.

A contribution can also be as simple as a +1 on issues tickets to show us what you would like to see in this gem.

That's it for now. Good Hacking...
