# encoding: utf-8

require 'spec_helper'

describe 'usergroup' do
  context 'when not exists' do
    it 'should be integer id' do
      usergroupids = zbx.usergroups.create(:name => gen_name('usergroup'))
      expect(usergroupids).to be_kind_of(Integer)
    end
  end

  context 'when exists' do
    before do
      @usergroup = gen_name 'usergroup'
      @usergroupids = zbx.usergroups.create(:name => @usergroup)
      @user = gen_name 'user'
      @userid = zbx.users.create(
        :alias => @user,
        :name => @user,
        :surname => @user,
        :passwd => @user,
        :usrgrps => @usergroupids.map{ |gid| { :usrgrpid => gid } }
      )

      @usergroup2 = gen_name 'usergroup'
      @usergroupids2 = zbx.usergroups.create(:name => @usergroup2)
      @user2 = gen_name 'user'
      @userid2 = zbx.users.create(
        :alias => @user2,
        :name => @user2,
        :surname => @user2,
        :passwd => @user2,
        :usrgrps => @usergroupids2.map{ |gid| { :usrgrpid => gid } }
      )
    end

    describe 'get_or_create' do
      it 'should return id' do
        expect(zbx.usergroups.get_or_create(:name => @usergroup)).to eq @usergroupids
      end
    end

    describe 'add_user' do
      it 'should return id' do
        expect(
          zbx.usergroups.add_user(
            :usrgrpids => [@usergroupids],
            :userids => [@userid2]
          )
        ).to eq @usergroupids
      end
    end

    describe 'update_users' do
      it 'should return id' do
        expect(
          zbx.usergroups.update_users(
            :usrgrpids => [@usergroupids2],
            :userids => [@userid2]
          )
        ).to eq @usergroupids2
      end
    end

    describe 'set_perms' do
      it 'should return id' do
        expect(
          zbx.usergroups.set_perms(
            :usrgrpid => @usergroupids,
            :hostgroupids => zbx.hostgroups.all.values,
            :permission => 3
          )
        ).to eq @usergroupids
      end
    end

    describe 'delete' do
      it 'should raise error when has users with only one group' do
        expect { zbx.usergroups.delete(@usergroupids) }.to raise_error(ZabbixApi::ApiError)
      end

      it 'should return id of deleted group' do
        usergroupids = zbx.usergroups.create(:name => gen_name('usergroup'))

        expect(zbx.usergroups.delete(usergroupids)).to eq usergroupids
      end
    end
  end
end
