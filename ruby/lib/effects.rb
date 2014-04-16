class Effect
  def setpixel i, values = [255,255,255]
    @p[i*3, values.length] = values
  end
  def clear
    @p = Array.new(@size*3, 1)
  end
end

class Blur
  def initialize app
    @app = app
    @filter = [0.1]*10+[0.8]*5+[0.1]*10
  end

  def call
    pixels = CyclicArray.new @app.call
    newpixels = Array.new NUM_SUBPIXELS
    pixels.each.with_index do |c, x|
      new_value = 0
      (0...@filter.length).each do |xx|
        sample_value = pixels[x - ((@filter.length - 1) / 2 + xx)*3]
        weight = @filter[xx]
        new_value += sample_value * weight
        new_value = 255 if new_value > 255
      end
      newpixels[x] = new_value.to_i
    end

    newpixels
  end
end

class RightSide
  def initialize app
    @app = app
  end
  def call
    # 88 + 182 + 330 = 600
    [0]*3*88+@app.call+[0]*3*330
  end
end

class Wheel < Effect
  attr_accessor :speed

  def initialize size=NUM_PIXELS
    @size = size
    @speed = 1
    @j = 0.upto(255).cycle
    clear
  end

  def call
    j = @j.next
    (0...@size).each do |i|
      setpixel i, wheel((i + j*@speed) & 255)
    end

    @p
  end
end

class Zap < Effect
  attr_accessor :speed

  def initialize size
    @size = size
    self.speed = 1
    clear
  end

  def speed= speed
    @speed = speed
    @j = 0.upto(@size).reject { |i| i % @speed != 0 }.cycle
  end

  def call
    j = @j.next
    max_length = @size - j
    (0...@size).each do |i|
      v = if i<j && i+50>j
        #$stderr.puts i-j
        (255*(j-i-150).abs/50.0).to_i
        #(255 * (i-j).abs/100.0).to_i
        #(255 * (i-j+100)/100.0).to_i #this one
        #255
      else
        1
      end
      setpixel i, [v]*3
    end

    @p
  end
end

class RainbowWheel < Wheel
  def wheel pos
    if pos < 85
      [pos * 3, 255 - pos * 3, 0]
    elsif pos < 170
      pos -= 85
      [255 - pos * 3, 0, pos * 3]
    else
      pos -= 170
      [0, pos * 3, 255 - pos * 3]
    end
  end
end

class Rotating
  attr_accessor :speed, :value
  def initialize app, size = NUM_PIXELS
    @app = app
    @size = size
    @value = 0
    @speed = 1
  end

  def call
    pixels = @app.call
    pixels.rotate(-value*3)
  end

  def value
    r = @value
    @value += @speed
    @value = 0 if @value >= @size

    @value
  end

  def speed= v
    @speed = v
  end
end

