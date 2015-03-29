# This module implements three classes that support deduplicating the
# spreadsheet of volumes from the HathiTrust compiled for the Princeton
# Prosody Archive project (PPA). A HathiDB object is used to read in volume
# records from a tab-delimited file; HathiObject objects contain one or
# more HathiItems (volumes).
# Author:: Clifford Wulfman (mailto:cwulfman@princeton.edu)

require 'csv'

# This class holds the items (volumes) associated with a particular
# record number.  The choice method picks the best item or items
# to keep during de-duplication.

class HathiObject
  attr_reader   :recordnumber
  attr_accessor :items


  def initialize(rnum, items = [])
    @recordnumber = rnum
    @items = items
  end



  # A HathiObject is considered a serial if any of its
  # items is a serial.
  def serial?
    @items.any? { |item| item.serial? }
  end


  # Sort the object's items by their rank.
  def sort
    @items.sort { |x,y| x.rank <=> y.rank }
  end


  # Choose the best items.  If the object is a serial, choose
  # all the items: we don't know how to choose among them if there
  # are duplicates.  Otherwise, if the object is not a serial, choose
  # the highest-ranking among the object's items.
  def chosen
    if self.serial?
      @items
    else
      self.sort.last
    end
  end

  def unchosen
    if self.serial?
      []
    else
      self.sort.slice(0, items.length - 1)
    end
  end

end

# HathiItem is an object overlay of a spreadsheet row.

class HathiItem
#  attr_accessor :owner, :vid, :itemid, :enumcron, :year, :status, :rank
  attr_accessor :qvol, :owner, :vid, :itemid, :unique, :brogan, :ppa, :ss, :vurl, :rurl, :enumcron, :year, :title, :author, :status, :other, :errors, :col16, :rank
  
  def initialize(line)
    #    @owner,@vid, @itemid,@enumcron,@year,@status = line.chomp.split("\t")
    # qvol is the qualified volume id: owner.vid .  It must be split.
    @qvol, @itemid, @unique, @brogan, @ppa, @ss, @vurl, @rurl, @enumcron, @year, @title, @author, @status, @other, @errors, @col16  = line.chomp.split("\t")
    @owner,@vid = @qvol.split('.')
    @rank = 0

  end

  # an item is a serial or edition if it has an enumcron: i.e., the enumcron is not empty
  def serial?
    !@enumcron.empty?
  end


  # Ranking is based on the origin of the physical volume.
  def rank
    case @owner
    # Prefer volumes from Princeton most strongly
    when 'njp'
      @rank = 4
    # Recap partners are next in order of preference
    when 'nyp', 'nnc1', 'nnc2.ark'
      @rank = 3
    # Followed by Borrow Direct partners
    when 'yale', 'hvd', 'coo', 'chi'
      @rank = 2
    # These are mentioned by Meagan
    when 'mdp', 'miun', 'uc1', 'uc2', 'loc.ark', 'uva', 'umn', 'dul1.ark', 'ien', 'inu', 'nc01.ark', 'pst', 'pur1', 'ucm', 'uiug', 'wu'
      @rank = 1
    # Anything else is unknown; rank lowest.
    else
      @rank = 0
    end
    @rank                       # return the rank
  end
end


# Override the to_s method to output a HathiItem as a tab-delimited
# string, matching the format of the input string. Using CSV.generate
# with the column separator set to the tab character is an idiomatic
# way to do this.
def to_s
  
  f = ""
  g = ""
  h = ""
  p = ""
  s = ""
  x = ""
  
  categories = []
  # get rid of whitespace before sp
  categories = @other.gsub(/\s+/,'').split(',')  if @other

  f = 1 if categories.include? 'F'
  g = 1 if categories.include? 'G'
  h = 1 if categories.include? 'H'
  p = 1 if categories.include? 'P'
  s = 1 if categories.include? 'S'
  x = 1 if categories.include? 'X'
  
  CSV.generate(:col_sep => "\t") do |out|
    # split the category field and write them to individual columns
    out << [@qvol, @itemid, @unique, @brogan, @ppa, @ss, @vurl, @rurl, @enumcron, @year, @title, @author, @status, f,g,h,p,s,x, @errors, @rank]
  end
end


# The HathiDB class holds the data being processed. It contains
# the path to the source file and an list of HathiItems
class HathiDB
  attr_accessor :itemlist
  attr_accessor :sourcefile
  attr_accessor :header_row

  def initialize(source)
    @sourcefile = source
    @itemlist = {}
    @header_row = "volid\trecid\tunique\tbrogan\tppa\tss\tvurl\trurl\tenum\tyear\ttitle\tauthor\tcat\tf\tg\th\tp\ts\tx\terrors"
    open(@sourcefile).each_with_index do |line, index|
      next if index == 0
      item = HathiItem.new(line)
      (@itemlist[item.itemid] ||= []) << item
    end
  end

  def object(id)
    obj = HathiObject.new(id, @itemlist[id])
    obj
  end

  # The chosen set is the chosen item or items from each object.
  def chosen
    the_set = []
    self.itemlist.each { |k,v| the_set << self.object(k).chosen  }
    the_set
  end

  # The unchosen set is the unchosen item or items from each object.
  def unchosen
    the_set = []
    self.itemlist.each { |k,v| the_set << self.object(k).unchosen  }
    the_set
  end


  def ranked
    ranked_set = []
    self.itemlist.each { |k,v| ranked_set << self.object(k).sort }
    ranked_set
  end

  def write_chosen(outfile)
    chosen_set = self.chosen
    File.open(outfile, "w") do |f|
      f.puts self.header_row
      chosen_set.each { |i| f.puts i }
    end
  end

  def write_unchosen(outfile)
    unchosen_set = self.unchosen
    File.open(outfile, "w") do |f|
      f.puts self.header_row
      unchosen_set.each { |i| f.puts i }
    end
  end

  def write_ranked(outfile)
    ranked_set = self.ranked
    File.open(outfile, "w") do |f|
      f.puts self.header_row
      ranked_set.each { |i| f.puts i }
    end
  end
    
end

