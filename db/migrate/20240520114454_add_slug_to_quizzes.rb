class AddSlugToQuizzes < ActiveRecord::Migration[7.1]
  def change
    add_column :quizzes, :slug, :string
  end
end
