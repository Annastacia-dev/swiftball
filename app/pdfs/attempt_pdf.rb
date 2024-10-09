# Generates a PDF for an Attempt
class AttemptPdf < Prawn::Document
  include Rails.application.routes.url_helpers

  def initialize(attempt:)
    super(top_margin: 20)
    @attempt = attempt
    @quiz = attempt.quiz
    @choices = @attempt.responses

    # Load Roboto font
    font_families.update("Roboto" => {
      normal: "#{Rails.root}/app/assets/fonts/Roboto-Thin.ttf",
      medium: "#{Rails.root}/app/assets/fonts/Roboto-Light.ttf",
      bold: "#{Rails.root}/app/assets/fonts/Roboto-Regular.ttf"
    })
    font "Roboto"
    page_header
    render_content
    footer
  end

  private

  def page_header
    # Header with logo, title, and result on the same line
    bounding_box([0, cursor], width: bounds.width) do
      # Logo on the left
      bounding_box([0, cursor], width: 100) do
        image "#{Rails.root}/app/assets/images/icon-48.png", width: 25, height: 25
      end

      # Quiz title in the middle
      bounding_box [100, cursor], width: 500 do
        text @quiz.title.upcase, size: 12, style: :medium, align: :center
      end

      # Result on the right
      bounding_box [bounds.width - 150, cursor], width: 150 do
        text "Points: #{@attempt.score}", size: 12, align: :right, style: :medium
      end
    end

    # Draw a line below the header
    move_down 10
    stroke_horizontal_rule
    move_down 10
  end

  def render_content
    move_down 20
  
    # Define the number of columns
    num_columns = 3
    column_width = bounds.width / num_columns

      @choices.each_with_index do |response, index|
        # Calculate the column and row positions
  
        # Create a bounding box for each cell
        
          # Show only the choice content  
          # Show the choice image if attached
          if response&.choice&.image&.attached?
            # Generate the image URL
            path = StringIO.open(response.choice.image.download)
            image path, width: 40 # Adjust image size if necessary
          end

          if response&.choice&.correct?
            points = response.question.points
          else
            points = 0
          end

          move_down 5

          text "#{response&.choice&.content&.titleize}", size: 10
      end
  end
  

  def footer
    # Add footer content if needed
  end

  def handle_image_error
    # Placeholder for image error handling
    puts "Image not available"
  end
end
