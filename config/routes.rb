Numbers2vcard::Application.routes.draw do
  match "convert" => "n2v#create", :as => 'convert', :method => :post
  root :to => "n2v#index"
end
