# frozen_string_literal: true

require "dotenv/load"

module Api::V1
  class DocsController < ApiController
    skip_before_action :authenticate_user
    skip_load_and_authorize_resource
    include Swagger::Blocks

    swagger_root do
      key :swagger, "2.0"
      info do
        key :version, "1.0.0"
        key :title, "Swagger Docs supermarket API"
        key :description, "Documentation for directional boring api "
        key :termsOfService, "http://helloreverb.com/terms/"
        contact do
          key :name, "Supermarket API"
        end
        license do
          key :name, "MIT"
        end
      end
      tag do
        key :name, "Supermarket API"
        key :description, "Supermarket API operations"
      end
      key :host, ENV["DOCS_HOST"]
      key :basePath, "/v1"
      key :consumes, ["application/json"]
      key :produces, ["application/json"]

      security_definition :auth do
        key :type, :apiKey
        key :name, "Authorization"
        key :in, :header
      end
    end

    # A list of all classes that have swagger_* declarations.
    SWAGGERED_CLASSES = [
      Docs::Authentication,
      Docs::V1::AuthenticationController,
      Docs::User,
      Docs::V1::UsersController,
      Docs::Supermarket,
      Docs::V1::SupermarketsController,
      Docs::Product,
      Docs::V1::ProductsController,
      Docs::SupermarketProduct,
      Docs::V1::SupermarketProductsController,
      Docs::SupermarketAddress,
      Docs::V1::SupermarketAddressController,
      Docs::SupermarketProductPrice,
      Docs::V1::SupermarketProductPricesController,
      Docs::Core,
      self,
    ].freeze

    def index
      swagger_data = Swagger::Blocks.build_root_json(SWAGGERED_CLASSES)
      File.open("#{Rails.root}/public/swagger.json", "wb") { |file| file.write(swagger_data.to_json) }
      redirect_to "/api-docs.html?url=swagger.json"
    end
  end
end
