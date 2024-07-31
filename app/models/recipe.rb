class Recipe < ApplicationRecord
  # after a save is made, if the name or ingredients have changed we get new content from chatgpt to upadte our recipe object
  after_save :set_content, if: -> { saved_change_to_name? || saved_change_to_ingredients? }

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
end
