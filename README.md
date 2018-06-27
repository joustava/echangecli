# Exchangecli

> A small Gem which interacts with the currencylayer API and a slack incoming webhook

## Installation

This gem is not published yet. See usage in Development section.

## Usage

For usage instructions run
```
$ bundle exec exe/exchangecli
```
Before you run the cli create an account at [currencylayer](https://currencylayer.com/) and note down your access_token.
Also create an account or workspace in slack and create an [incoming webhook](https://api.slack.com/incoming-webhooks)
and note down the webhook uri.

Then run
```
$ bundle exec exe/exchangecli init
```
and follow then instructions.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/exchangecli. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Exchangecli project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/exchangecli/blob/master/CODE_OF_CONDUCT.md).
