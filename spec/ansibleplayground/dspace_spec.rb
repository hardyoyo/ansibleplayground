require 'spec_helper'

# check packages
describe package('httpd'), :if => os[:family] == 'redhat' do
  it { should be_installed }
end

describe package('git'), :if => os[:family] == 'redhat' do
  it { should be_installed }
end

describe package('postgresql95'), :if => os[:family] == 'redhat' do
  it { should be_installed }
end

# check services
describe service('httpd'), :if => os[:family] == 'redhat' do
  it { should be_enabled }
  it { should be_running }
end

describe service('postgresql-9.5'), :if => os[:family] == 'redhat' do
  it { should be_enabled }
  it { should be_running }
end

describe service('dspace'), :if => os[:family] == 'redhat' do
  it { should be_enabled }
  it { should be_running }
end

#check ports
describe port(5432) do
  it { should be_listening.on('127.0.0.1').with('tcp') }
end

describe port(80) do
  it { should be_listening.on('0.0.0.0').with('tcp') }
end

describe port(8081) do
  it { should be_listening.on('127.0.0.1').with('tcp') }
end

describe port(8010) do
  it { should be_listening.on('127.0.0.1').with('tcp') }
end

# check users and groups
describe user('dspace') do
      it { should exist }
end

describe user('dspace') do
      it { should have_authorized_key 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCkq8Aa3Ms01Pa5kxorfHzZl/FkLCAvVbCnC3TSQGpjVqhhhsXivJs7DtO+ibgs8kjbW8s/dLtbT68CUdhyJh9nMQLQVceahC+MMQ1TwqjO4acmjBcqiecnyF7vMjAXXDp7hfwF05hTQoM7xCWjBpdbVpLWKnyqhv2ZQbtjGm00JRxaju1QZniPlNIsj7jCBv7en7PcU+pfx83RA2NkQbZKnJ3yfFAVGLUzeyevIIIpfHSqJTxZMff34kNEScSN4MO0JRQP0b4qcIoQoGBikAA47YQMQwJzcU2fg5/exZczzG5dbl+s1Ph5aGixGUhSXvOjjrxD43i3uq2C3z6+OJC1 hpottinger@Hardys-MacBook-Air.local' }
end

describe user('dspace') do
      it { should have_authorized_key 'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAsg6VC5p+f7vnzyUmcwiZOBxHhp19YBxpXX4RhbS48Zc7fm6Booq6A63XmCABc/aHQ/AsbbLM8hLq6pzns8YmuOhoxLXGUOaXz0Jj5HvSEwtAuZQAdQ6+vdYD9lahkap1Xz/lA9sFTMP7ZpWVaSApp9aFyBHKFMcrZ2AyOriTmUeKBfFNeQmFVsEMkQTtZytN8hYs6oz7BzIoFswNcpEXk84bFId7wStGgsKWJd7N5hSG8qv8X8E1TeN1z94VJBm1D6XFl1Re27bdOvMDTX1Sksq/d+x9myriEuxmsiwETf0yJ2f9Eld3aigmpwWtBnySr+7iCChY33xyceQ2enU4RQ== edson@lit265v' }
end
