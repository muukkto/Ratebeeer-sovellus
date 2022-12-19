class StylesController < ApplicationController
  
    def index
      @styles = Style.all
      @beers = Beer.all
    end

end