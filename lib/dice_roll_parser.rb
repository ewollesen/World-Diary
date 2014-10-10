module DiceRollParser
  extend ActionView::Helpers::TagHelper

  DICE_ROLL_RE = /\{(\d*)?d(\d+)((?:\+|-)\d+)?\}/

  def self.parse(text)
    # This block is sensitive to the effects of html_safe. If you find that
    # the regexp match variables ($1, $2, etc) are all nil, then an errant
    # call to html_safe could be the culprit.
    text.gsub(DICE_ROLL_RE) do |matched_text|
      rolls = $1.empty? ? 1 : $1.to_i rescue 1
      sides = Integer($2)
      mod = $3.empty? ? 0 : $3.to_i rescue 0
      content_tag("span",
                  roll_template(rolls, sides, mod),
                  :class => "dm",
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
