class StaticPagesController < ApplicationController
  def home
    render html: "home"
  end

  def help
  end
end
