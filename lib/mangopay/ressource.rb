module MangoPay
  class Ressource

    protected

    def self.post_request(route, data)
      request('POST', route, data)
    end

    def self.get_request(route, options=nil)
      request('GET', route, nil, options)
    end

    def self.put_request(route, data)
      request('PUT', route, data)
    end

    def self.delete_request(route)
      request('DELETE', route)
    end

    def self.form_request(upload_url, file_name, file_path)
      url = URI(upload_url)
      File.open(file_path) do |file|
        req = Net::HTTP::Post::Multipart.new(url.request_uri, :file => UploadIO.new(file, file_type(file_path), file_name))
        res = Net::HTTP.start(url.host, url.port, :use_ssl => url.scheme == 'https') do |http|
          http.request(req)
        end
        res.code == "200" ? true : false
      end
    end

    private

    def self.request(method, route, data=nil, options=nil)
      path = path_for(route, options)
      uri = uri_for(path)
      method = method.upcase
      data = data.to_json unless data.nil?
      headers = header_for(method, path, data)
      res = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
        case method
        when 'POST'   then request = Net::HTTP::Post.new(uri.request_uri, headers)
        when 'GET'    then request = Net::HTTP::Get.new(uri.request_uri, headers)
        when 'PUT'    then request = Net::HTTP::Put.new(uri.request_uri, headers)
        when 'DELETE' then request = Net::HTTP::Delete.new(uri.request_uri, headers)
        else
          return {}
        end
        request.body = data unless data.nil?
        http.request request
      end
      begin
        JSON.parse(res.body)
      rescue JSON::ParserError
        res.body.is_a?(String) ? res.body : {' ErrorCode' => -1 }
      end
    end

    def self.key
      OpenSSL::PKey::RSA.new(File.read(MangoPay.configuration.key_path), MangoPay.configuration.key_password)
    end

    def self.path_for(route, options)
      File.join('', 'v1', 'partner', MangoPay.configuration.partner_id, route.to_s) + "?ts=#{Time.now.to_i.to_s}" + (options.nil? ? '' : ('&' + options))
    end

    def self.uri_for(path)
      URI(File.join(MangoPay.configuration.base_url, path))
    end

    def self.sign(data)
      Base64.encode64(key.sign('sha1', data)).to_s.chomp.gsub(/\n/, '')
    end

    def self.signature_for(method, path, data)
      sign("#{method}|#{path}|" + (data.nil? ? '' : "#{data}|"))
    end

    def self.header_for(method, path, data)
      { 'X-Leetchi-Signature' => signature_for(method, path, data), 'Content-Type' => 'application/json' }
    end

    def self.file_type(file_path)
      file_types = {
        'jpg' => 'image/jpeg',
        'jpeg' => 'image/jpeg',
        'gif' => 'image/gif',
        'png' => 'image/png',
        'pdf' => 'image/pdf'
      }
      file_types[file_path.gsub(/^[^\.]+\./, "")]
    end
  end
end

