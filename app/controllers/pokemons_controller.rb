require 'httparty'
class PokemonsController < ApplicationController
  def index
    @pokemons = fetch_pokemons
  end

  def show
    pokemon_id = params[:id]
    response = HTTParty.get("https://pokeapi.co/api/v2/pokemon/#{pokemon_id}")
    @pokemon = response.parsed_response
  end

  private

  def fetch_pokemons
    max_pokemon = 151

    Rails.cache.fetch("pokemons_data", expires_in: 12.hours) do
      pokemons = []

      (1..max_pokemon).each do |i|
        response = HTTParty.get("https://pokeapi.co/api/v2/pokemon/#{i}")
        if response.success?
          pokemons << {
            id: response["id"],
            name: response["name"],
            sprite_url: response["sprites"]["front_default"]
          }
        end
      end

      pokemons
    end
  end

end
