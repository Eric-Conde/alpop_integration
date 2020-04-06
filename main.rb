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

# Features
locatarios_inadimplentes = Superlogica::Locatario.inadimplentes

locatarios_inadimplentes.each do |locatario|
  puts '-------------------------------'
  puts "#{locatario.nome}: #{locatario.cobrancas_atrasadas}"
end
