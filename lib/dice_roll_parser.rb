module DiceRollParser
  extend ActionView::Helpers::TagHelper

  DICE_ROLL_RE = /\{(\d*)?d(\d+)((?:\+|-)\d+)?\}/

  def self.parse(text)
    text.gsub(DICE_ROLL_RE) do |matched_text|
      rolls = $1.empty? ? 1 : $1.to_i rescue 1
      sides = Integer($2)
      mod = $3.empty? ? 0 : $3.to_i rescue 0
      content_tag("dm",
                  roll_template(rolls, sides, mod),
                  data: {sides: sides, rolls: rolls, mod: mod})
    end
  end


  private

  def self.roll_template(rolls, sides, mod)
    t, args = "d%d", [sides]
    if 0 != mod
      t << "%+d"
      args << mod
    end
    if 1 != rolls
      t = "%d" + t
      args.unshift(rolls)
    end

    t % args
  end
end
