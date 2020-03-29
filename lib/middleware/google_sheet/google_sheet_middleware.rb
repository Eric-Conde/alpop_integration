# frozen_string_literal: true

require 'middleware'
require 'google/apis/sheets_v4'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'fileutils'

# Middleware specific functions to integrates with Google Sheets API.
class GoogleSheetMiddleware < Middleware
  # Constants.
  APPLICATION_NAME = 'alpop_integration'

  attr_accessor :service

  def initialize
    super
    access_token = seek_api('google_sheet')[1]
    @service = initialize_google_sheets_api(access_token)
  end

  def do_request(spreadsheet_id, range)
    @service.get_spreadsheet_values(spreadsheet_id, range)
  end

  private

  def initialize_google_sheets_api(access_token)
    service = Google::Apis::SheetsV4::SheetsService.new
    client_options = service.client_options
    client_options.application_name = APPLICATION_NAME
    service.key = access_token
    service
  end
end
