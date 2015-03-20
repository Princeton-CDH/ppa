# HathiObject and HathiItem

class HathiObject
  attr_reader   :recordnumber
  attr_accessor :items

  def initialize(rnum, items)
    @recordnumber = rnum
    @items = items
  end

  def serial?
    @items.any? { |item| item.serial? }
  end

  def sort
    @items.sort { |x,y| x.rank <=> y.rank }
  end

  def choice
    if self.serial?
      @items
    else
      self.sort.last
    end
  end

end

class HathiItem
  attr_accessor :owner
  attr_accessor :vid
  attr_accessor :itemid
  attr_accessor :enumcron
  attr_accessor :year
  attr_accessor :status
  attr_accessor :rank

  def initialize(line)
    @owner,@vid, @itemid,@enumcron,@year,@status = line.chomp.split("\t")
    @rank = 0
  end

  def serial?
    # an item is a serial or edition if it has an enumcron
    !@enumcron.empty?
  end

  def rank
    case @owner
    when 'njp'
      @rank = 4
      
    when 'nnc1', 'nnc2.ark'
      @rank = 3
      
    when 'yale', 'hvd', 'coo', 'chi'
      @rank = 2

    else
      @rank = 1
    end
    @rank
  end
end


class HathiDB
  attr_accessor :oblist
  attr_accessor :sourcefile

  def initialize(source)
    @sourcefile = source
    @oblist = {}
    open(@sourcefile).each do |line|
    item = HathiItem.new(line)
    (@oblist[item.itemid] ||= []) << item
    end
  end

  def object(id)
    obj = HathiObject.new(id, @oblist[id])
    obj
  end

  def culled
    the_set = []
    self.oblist.each { |k,v| the_set << self.object(k).choice  }
    the_set
  end
end

