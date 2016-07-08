class StocksController < ApplicationController
  def search
    if params[:symbol]
      @stock = Stock.find_by_symbol(params[:symbol])
      @stock ||= Stock.new_from_lookup(params[:symbol])

      if @stock
        # render json: @stock
        render partial: 'lookup'
      else
        render status: :not_found, nothing: true
      end
    end
  end
end
