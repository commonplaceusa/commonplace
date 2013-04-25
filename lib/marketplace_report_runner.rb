class MarketplaceReportRunner
  def perform!
    grouped = Transaction.all.group_by do |t|
      t.created_at.to_date
    end
    amounts = {}
    grouped.each do |k, v|
      amounts[k] = v.map { |o| o.price_in_cents.to_f / 100 }
    end
  end
end
