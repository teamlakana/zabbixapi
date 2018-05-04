# encoding: utf-8

require 'spec_helper'

describe 'usergroup' do
  context 'when not exists' do
    it 'should be integer id' do
      usergroupid = zbx.usergroups.create(:name => gen_name('usergroup'))
      expect(usergroupid).to be_kind_of(Integer)
    end
  end

  context 'when exists' do
    before do
      @usergroup = gen_name 'usergroup'
      @usergroupid = zbx.usergroups.create(:name => @usergroup).map{ |gid| { :usrgrpid => gid } }
      @user = gen_name 'user'
      @userid = zbx.users.create(
        :alias => @user,
        :name => @user,
        :surname => @user,
        :passwd => @user,
        :usrgrps => @usergroupid
      )

      @usergroup2 = gen_name 'usergroup'
      @usergroupid2 = zbx.usergroups.create(:name => @usergroup2).map{ |gid| { :usrgrpid => gid } }
      @user2 = gen_name 'user'
      @userid2 = zbx.users.create(
        :alias => @user2,
        :name => @user2,
        :surname => @user2,
        :passwd => @user2,
        :usrgrps => @usergroupid2
      )
    end

    describe 'get_or_create' do
      it 'should return id' do
        expect(zbx.usergroups.get_or_create(:name => @usergroup)).to eq @usergroupid
      end
    end

    describe 'add_user' do
      it 'should return id' do
        expect(
          zbx.usergroups.add_user(
            :usrgrpids => [@usergroupid],
            :userids => [@userid2]
          )
        ).to eq @usergroupid
      end
    end

    describe 'update_users' do
      it 'should return id' do
        expect(
          zbx.usergroups.update_users(
            :usrgrpids => [@usergroupid2],
            :userids => [@userid2]
          )
        ).to eq @usergroupid2
      end
    end

    describe 'set_perms' do
      it 'should return id' do
        expect(
          zbx.usergroups.set_perms(
            :usrgrpid => @usergroupid,
            :hostgroupids => zbx.hostgroups.all.values,
            :permission => 3
          )
        ).to eq @usergroupid
      end
    end

    describe 'delete' do
      it 'should raise error when has users with only one group' do
        expect { zbx.usergroups.delete(@usergroupid) }.to raise_error(ZabbixApi::ApiError)
      end

      it 'should return id of deleted group' do
        usergroupid = zbx.usergroups.create(:name => gen_name('usergroup'))

        expect(zbx.usergroups.delete(usergroupid)).to eq usergroupid
      end
    end
  end
end
