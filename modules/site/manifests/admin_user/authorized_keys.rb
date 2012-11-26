define "site::admin_user::authorized_keys", :authorized_keys do
  require 'base64'

  resources = {}
  @authorized_keys.each_with_index do |key, idx|
    name = "#{@name}'s key ##{idx + 1}"
    decoded_key = Base64.decode64(key)
    type_length = decoded_key.unpack('N')[0] # 32-bit integer, network byte-order
    type = decoded_key[4...4+type_length]
    resources[name] = {
      'user' => @name,
      'type' => type,
      'key'  => key
    }
  end

  create_resources ['ssh_authorized_key', resources]
end
