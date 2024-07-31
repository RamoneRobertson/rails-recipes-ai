require "open-uri"
class Recipe < ApplicationRecord
  # after a save is made, if the name or ingredients have changed we get new content from chatgpt to upadte our recipe object
  after_save if: -> { saved_change_to_name? || saved_change_to_ingredients? } do
    set_content
    set_photo
  end

  has_one_attached :photo

  # We only load content from chatgpt if the content is blank.
  # Otherwise we just load the static string that is already stored in the database
  def content
    if super.blank? #if the content normally gives you nothing
      set_content
    else
      super
    end
  end

  private

  def set_content
    # Create a new openai client
    client = OpenAI::Client.new

    # make a new prompt to openai to get a response back from chatgpt
    response = client.chat(parameters: {
      model: "gpt-3.5-turbo",
      messages: [{
        role: "user",
        content: "Make a simple recipe for #{name} with ingredients #{ingredients}, format the instructions into an organized list and dont list the ingredients"
      }]
    })

    # Getting the content from chatgpt and updating the content for the recipe object
    new_content = response["choices"][0]["message"]["content"]
    update(content: new_content)
    return new_content
  end

  def set_photo
    client = OpenAI::Client.new
    response = client.images.generate(parameters: {
      prompt: "Give me an image of a recipe for #{name} with ingredients #{ingredients}",
      size: "256x256"
    })
    id = response["data"][0]["url"]

    # This is the url given by chatgpt from the prompt
    url =  response["data"][0]["url"]

    # In order to attach the photo to the recipe we must open it from the internet
    file = URI.open(url)

    # If a photo already exists we delete it and atach the new photo
    photo.purge if photo.attached?

    # Now we send the file to cloudinary and attach it to the recipe
    photo.attach(io: file, filename: "#{name}.png", content_type: "image/png")
    return photo
  end
end
