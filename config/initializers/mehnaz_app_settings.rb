class MehnazAppSettings < Settingslogic
  source "#{Rails.root}/config/mehnaz_app.yml"
  namespace Rails.env

  def self.build_url
    custom_port = if [443, 80].exclude?(port.to_i)
      ":#{port}"
    else
      nil
    end
    app_path =
    [ protocol,
      "://",
      host,
      custom_port,
      relative_url_root
    ].join('')
  end
end
MehnazAppSettings['api_version'] ||= 'v1'
MehnazAppSettings['host'] ||= 'localhost'
MehnazAppSettings['relative_url_root'] ||= ''
MehnazAppSettings['url'] ||= MehnazAppSettings.build_url

MehnazAppSettings['asset_host'] ||= Settingslogic.new({})
MehnazAppSettings['asset_host']['enabled'] ||= false