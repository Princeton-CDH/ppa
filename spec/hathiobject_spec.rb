require 'spec_helper'

RSpec.describe 'hathiobject' do
  describe '.new' do
    context "with a valid HathiTrust record number input" do
      it "contains a valid recordnumber property" do
        idnum = "011261282"
        obj = HathiObject.new(idnum)
        expect(obj.recordnumber).to eq(idnum)
        expect(obj.recordnumber =~ /[0-9]{9}+/).to be_truthy
      end
    end
  end

end

RSpec.describe "hathiitem" do
  describe '.new' do
    context "with valid input" do
      it "contains valid fields" do
        line = "owner\tvid\titemid\tenumcron\tyear\tstatus"
        item = HathiItem.new(line)
        expect(item.owner).to eq('owner')
        expect(item.vid).to eq('vid')
        expect(item.itemid).to eq('itemid')
        expect(item.enumcron).to eq('enumcron')
        expect(item.year).to eq('year')
        expect(item.status).to eq('status')        
      end
    end
  end
  describe '.serial?' do
    context "when item has enumcron" do
      it "is true" do
        line= "owner\tvid\titemid\tenumcron\tyear\tstatus"
        item = HathiItem.new(line)
        expect(item.serial?).to be_truthy
      end
    end
    context "when item doesn't have an enumcron" do
      it "is false" do
        line= "owner\tvid\titemid\t\tyear\tstatus"
        item = HathiItem.new(line)
        expect(item.serial?).not_to be_truthy
      end
    end
  end
  describe '.rank' do
    context "when owner is njp" do
      it "is 4" do
        line= "njp\tvid\titemid\tenumcron\tyear\tstatus"
        item = HathiItem.new(line)
        expect(item.rank).to eq(4)
      end
    end
    context "when owner is nnc1 or nnc2.ark" do
      it "is 3" do
        line= "nnc1\tvid\titemid\tenumcron\tyear\tstatus"
        item = HathiItem.new(line)
        expect(item.rank).to eq(3)
        item.owner = "nnc2.ark"
        expect(item.rank).to eq(3)        
      end
    end
    context "when owner is yale, hvd, coo, or chi" do
      it "is 2" do
        line= "yale\tvid\titemid\tenumcron\tyear\tstatus"
        item = HathiItem.new(line)
        expect(item.rank).to eq(2)
        item.owner = "hvd"
        expect(item.rank).to eq(2)        
        item.owner = "coo"
        expect(item.rank).to eq(2)        
        item.owner = "chi"
        expect(item.rank).to eq(2)
      end
    end
    context "when owner is miun, uc1, etc" do
      it "is 1" do
        owners = ['mdp', 'miun', 'uc1', 'uc2', 'loc.ark', 'uva', 'umn', 'dul1.ark', 'ien', 'inu', 'nc01.ark', 'pst', 'pur1', 'ucm', 'uiug', 'wu']

        line= "\t\tvid\titemid\tenumcron\tyear\tstatus"
        item = HathiItem.new(line)
        owners.each do |owner|
          item.owner = owner
          expect(item.rank).to eq(1)
        end
      end
    end
  end
end
