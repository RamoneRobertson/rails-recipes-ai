# This file will run when the rails project starts

# Here we are setting the access token to the variable set in our .env file (OPENAI_ACCESS_TOKEN)
OpenAI.configure do |config|
  config.access_token = ENV.fetch("OPENAI_ACCESS_TOKEN")
end
