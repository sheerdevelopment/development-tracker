module SessionsHelper

  CLIENT_ID = APP_CONFIG["github_client_id"]
  CLIENT_SECRET = APP_CONFIG["github_client_secret"]

  def scopes
    "user:email,repo".freeze
  end

  def client
    @client ||= Octokit::Client.new(
      :access_token => session[:access_token],
      :auto_paginate => true)
  end

  def authorize_url
    auth_client = Octokit::Client.new(:client_id => CLIENT_ID,
      :client_secret => CLIENT_SECRET)
    auth_client.authorize_url(CLIENT_ID, :scope => scopes)
  end

  def exchange_token(code)
    Octokit.exchange_code_for_token(code, CLIENT_ID, CLIENT_SECRET)[:access_token]
  end

  def authenticated?
    !session[:access_token].blank?
  end

  def log_out
    session[:access_token] = nil
    @current_username = nil
  end

  def current_username
    @current_username ||= name_for_slack(client.user.name)
  end

  def name_for_slack(name)
    "#{name[0]}#{name.split(' ').last}".downcase
  end

  def ops?
    APP_CONFIG["Ops"].include?(current_username)
  end

end
