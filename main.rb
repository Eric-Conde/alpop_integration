# frozen_string_literal: true

# Usage example: how to use integrations and Ruby objects.

# Setup
$LOAD_PATH.unshift(Dir.pwd)
$LOAD_PATH.unshift(Dir.pwd + '/lib')
$LOAD_PATH.unshift(Dir.pwd + '/helpers')

# Requires
require 'singleton'
require 'yaml'
require 'json'
require 'http'
require 'middleware'
require 'superlogica/locatario'
require 'csv'
require 'date'

require 'byebug'


def export_csv(csv_output)
  CSV.open("tmp/inadimplentes.csv", "w", write_headers: true,
    headers: ["Data","Inadimplentes","Cobranças vencidas"]) do |csv|
    csv_output.each do |row|
      csv << row
    end
  end
end


starts_at = Date.new(2018,06)
ends_at = Date.new(2020,03)

date_range = (starts_at..ends_at).map{|d| [d.year, d.month]}.uniq
csv_output = []

# Iterate over months
dtInicio = '06/01/2018'
date_range.each do |year_month|
  year = year_month[0]
  month = year_month[1]
  inadimplentes = []
  
  date = Date.civil(year, month, -1)
  day = date.day
  
  dtFim = "#{month}/#{day}/#{year}"

  puts "\nDebug (#{Time.now}): Requisitando inadimplentes para #{month}/#{year}"

  inadimplentes = Superlogica::Locatario.inadimplentes(dtInicio, dtFim)

  puts "Debug (#{Time.now}): Não há inadimplentes para #{month}/#{year}" if inadimplentes.empty?
  puts "Debug (#{Time.now}): Inadimplentes para #{month}/#{year}: #{inadimplentes.size}" if !inadimplentes.empty?

  cobrancas_atrasadas = 0
  inadimplentes&.each do |inadimplente|
    cobrancas_atrasadas += inadimplente.cobrancas_atrasadas
  end

  csv_output << ["#{month}/#{year}", inadimplentes&.size, cobrancas_atrasadas]
end

puts "\nDebug (#{Time.now}): Exportando CSV..."
export_csv(csv_output)
