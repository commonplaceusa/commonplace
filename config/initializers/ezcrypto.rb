ENV['facebook_password'] ||= "12345"
ENV['facebook_salt'] ||= "12321"
$CryptoKey = EzCrypto::Key.with_password ENV['facebook_password'], ENV['facebook_salt']
