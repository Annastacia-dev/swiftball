require 'web-push'

vapid_keys = WebPush.generate_key
puts "VAPID Public Key: #{vapid_keys.public_key}"
puts "VAPID Private Key: #{vapid_keys.private_key}"
