# OfflineBroadcaster
This gem aims to deliver messages/data or save into database for later delivery to the receiver according to their (online/offline) status.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'offline_broadcaster'
```

And then execute:

    $ bundle install

## Usage

#### Create `Adapter` to listen for the messages:

- It should inherit `OfflineBroadcaster::Adapter` (It can be placed inside model or wherever you want).
- Overload collect method as below example.
- So, whenever user receives a message this method will be called. Like, for online users it will be called immediately and for offline users it will be called once user comes online.

```ruby
class User::OfflineManager < OfflineBroadcaster::Adapter

  # This method called when user comes online.
  def self.collect(channel:, receiver:, data:)
    # Here we can safely publish message to redis channel
    # OR we can publish it on ActionCable channel.
  end
end

```

#### Add this to your `User` model:

- While calling `acts_as_offline_receiver` pass `online_attribute` so gem can identify user status (In our case we have `online` column in our database).
- And also need to pass adapter we just wrote.

```ruby
class User < ApplicationRecord
  acts_as_offline_receiver online_attribute: :online, adapter: User::OfflineManager
end
```

#### Let's test it:

```ruby
receiver = User.last
receiver.online
# => false

# Send a message
User::OfflineManager.deliver(channel: 'greeting_channel', receiver: receiver, data: 'Hello online user!!')
# => # Some insert query will going to run.

# Update the user status
receiver.update(online: true)
# => User::OfflineManager#collect will be called.
```

## How it works?
1. This gem will observe the given attribute changes (to identify user online/offline status).
2. While sending a message if user is online then that message will be delivered immediately
3. Otherwise, it will store that into database and when user comes online again those pending messages will be delivered.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/vivekmiyani/offline_broadcaster. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/vivekmiyani/offline_broadcaster/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the OfflineBroadcaster project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/vivekmiyani/offline_broadcaster/blob/master/CODE_OF_CONDUCT.md).
