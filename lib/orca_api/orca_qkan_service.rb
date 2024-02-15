# frozen_string_literal: true

require_relative "service"

module OrcaApi
  # @!group 患者関連情報

  # @!method get_patient_payget_service
  #   @see OrcaQkanService::PatientPaygetService#get
  # @!method qkan_provider_list_service
  #   @see OrcaQkanService::QkanProviderListService#get
  # @!method qkan_patient_service
  #   @see OrcaQkanService::QkanPatientService#create
  # @!method qkan_homecare_master_service
  #   @see OrcaQkanService::QkanHomecareMasterService#get

  # @!endgroup
  class OrcaQkanService < Service
    %w(
      PatientPaygetService
      QkanProviderListService
      QkanPatientService
      QkanHomecareMasterService
    ).each do |class_name|
      method_suffix = Client.underscore(class_name)
      require_relative "orca_qkan_service/#{method_suffix}"
      klass = const_get(class_name)

      method_names = klass.instance_methods & (klass.instance_methods(false) + %i(get update fetch create)).uniq
      method_names.each do |method_name|
        define_method(:"#{method_name}_#{method_suffix}") do |*args|
          klass.new(orca_api).send(method_name, *args)
        end
      end
    end
  end
end