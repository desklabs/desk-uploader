Mongoid::EncryptedFields.cipher = Gibberish::AES::CBC.new(ENV['SIDEKIQ_ENCRYPTION_KEY'])
Mongoid::QueryCache.enabled = true