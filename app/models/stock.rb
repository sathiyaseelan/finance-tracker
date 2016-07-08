class Stock < ActiveRecord::Base
    has_many :user_stocks
    has_many :users, through: :user_stocks
    
  def self.find_by_symbol(ticker_symbol)
    where(ticker: ticker_symbol).first
  end

  def self.new_from_lookup(ticker_symbol)
    looked_up_stock = StockQuote::Stock.quote(ticker_symbol)
    return nil unless looked_up_stock.name
    new_stock = new(ticker: looked_up_stock.symbol, name: looked_up_stock.name)
    new_stock.last_price = new_stock.price(looked_up_stock)
    new_stock
  end

  def price(looked_up_stock = StockQuote::Stock.quote(ticker))
    return 'Unavailable' unless looked_up_stock
    closing_price = looked_up_stock.close
    return "#{closing_price} (Closing)" if closing_price
    opening_price = looked_up_stock.open
    return "#{opening_price} (Opening)" if opening_price
  end
end
