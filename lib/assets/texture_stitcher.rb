require 'rmagick'
class TextureStitcher

  include Magick

  def self.stitch(to_stitch)
    size_x = to_stitch.count
    size_y = to_stitch[0].count

    texture_png = ImageList.new

    size_x.times do |x|
      row_image = ImageList.new
      size_y.times do |y|
        if to_stitch[x][y]
          col_image = Image.read(to_stitch[x][y]).first
          row_image.push col_image
        end
      end
      texture_png.push row_image.append(false)
    end

    texture_png.append(true)
  end
end