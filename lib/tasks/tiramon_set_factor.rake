namespace :tiramon_set_factor do
  desc "tiramon_set_factor"
  task tiramon_set_factor: :environment do
    Tiramon.where(factor_name: nil).where.not(tiramon_trainer: nil).find_each do |t|
      #t.generate_factor
      t.factor_name = Tiramon.get_factor_name(t)
      t.save!
    end
  end
end
