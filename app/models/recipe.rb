class Recipe < ApplicationRecord
  # def content
  #  Rails cache.fetch will store the value calculated so that when you reload/refresh it doesnt have to make another request. Instead it keeps the value calculated previously
  #  The value will be stored until time expires or there is a change to the object key
  #   Rails.cache.fetch("#{cache_key_with_version}/content") do
  #     # Create a new openai client
  #     client = OpenAI::Client.new

  #     # make a new prompt to openai to get a response back from chatgpt
  #     response = client.chat(parameters: {
  #       model: "gpt-3.5-turbo",
  #       messages: [{
  #         role: "user",
  #         content: "Make a simple recipe for #{name} with ingredients #{ingredients}"
  #       }]
  #     })
  #     return response["choices"][0]["message"]["content"]
  #   end
  # end
end
