require 'date'
require 'time'
require 'drb'
require 'fileutils'
require 'yaml'

begin             # first choice--for speed
  require 'faster_csv'
rescue LoadError  # second choice--slower but standard
  require 'csv'
end

#
# :main:KirbyBase
# :title:KirbyBase Class Documentation
# KirbyBase is a class that allows you to create and manipulate simple,
# plain-text databases.  You can use it in either a single-user or
# client-server mode.  You can select records for retrieval/updating using
# code blocks.
#
# Author::    Jamey Cribbs (mailto:jcribbs@twmi.rr.com)
# Homepage::  http://www.netpromi.com/kirbybase.html
# Copyright:: Copyright (c) 2005 NetPro Technologies, LLC
# License::   Distributes under the same terms as Ruby
# History:
# 2005-03-28:: Version 2.0
# * This is a completely new version.  The interface has changed
#   dramatically.
# 2005-04-11:: Version 2.1
# * Changed the interface to KirbyBase#new and KirbyBase#create_table.  You
#   now specify arguments via a code block or as part of the argument list.
# * Added the ability to specify a class at table creation time.
#   Thereafter, whenever you do a #select, the result set will be an array
#   of instances of that class, instead of instances of Struct.  You can
#   also use instances of this class as the argument to KBTable#insert,
#   KBTable#update, and KBTable#set.
# * Added the ability to encrypt a table so that it is no longer stored as
#   a plain-text file.
# * Added the ability to explicity specify that you want a result set to be
#   sorted in ascending order.
# * Added the ability to import a csv file into an existing table.
# * Added the ability to select a record as if the table were a Hash with
#   it's key being the recno field.
# * Added the ability to update a record as if the table were a Hash with
#   it's key being the recno field.
# 2005-05-02:: Version 2.2
# * By far the biggest change in this version is that I have completely
#   redesigned the internal structure of the database code.  Because the
#   KirbyBase and KBTable classes were too tightly coupled, I have created
#   a KBEngine class and moved all low-level I/O logic and locking logic
#   to this class.  This allowed me to restructure the KirbyBase class to
#   remove all of the methods that should have been private, but couldn't be
#   because of the coupling to KBTable.  In addition, it has allowed me to
#   take all of the low-level code that should not have been in the KBTable
#   class and put it where it belongs, as part of the underlying engine.  I
#   feel that the design of KirbyBase is much cleaner now.  No changes were
#   made to the class interfaces, so you should not have to change any of
#   your code.
# * Changed str_to_date and str_to_datetime to use Date#parse method.
# * Changed #pack method so that it no longer reads the whole file into
#   memory while packing it.
# * Changed code so that special character sequences like &linefeed; can be
#   part of input data and KirbyBase will not interpret it as special
#   characters.
# 2005-08-09:: Version 2.2.1
# * Fixed a bug in with_write_lock.
# * Fixed a bug that occurred if @record_class was a nested class.
# 2005-09-08:: Version 2.3 Beta 1
# * Added ability to specify one-to-one links between tables.
# * Added ability to specify one-to-many links between tables.
# * Added ability to specify calculated fields in tables.
# * Added Memo and Blob field types.
# * Added indexing to speed up queries.
# 2005-10-03:: Version 2.3 Beta 2
# * New column type:  :YAML.  Many thanks to Logan Capaldo for this idea!
# * Two new methods:  #add_table_column and #drop_table_column.
# * I have refined the select code so that, when you are doing a one-to-one
#   or one-to-many select, if an appropriate index exists for the child
#   table, KirbyBase automatically uses it.
# * I have changed the designation for a one-to-one link from Link-> to
#   Lookup-> after googling helped me see that this is a more correct term
#   for what I am trying to convey with this link type.
# 2005-10-10:: Version 2.3 Production
# * Added the ability to designate a table field as the "key" field, for
#   Lookup purposes.  This simply makes it easier to define Lookup fields.
# * This led me to finally give in and add "the Hal Fulton Feature" as I am
#   forever going to designate it.  You can now specify a Lookup field
#   simply by specifying it's field type as a table, for example:
#   :manager, :person (where :manager is the field name, and :person is the
#   name of a table).  See the docs for the specifics or ask Hal. :)
#
# 2005-11-13:: Version 2.4
# * Added a new column type: :Time.  Thanks to George Moschovitis for coding
#   this enhancement.
# * Added more functionality to Memo and Blob fields.  They are no longer
#   just read-only.  You can now also write to them from KirbyBase.  The
#   interface for Memo and Blob fields has changed because of this.
# * Added the ability to specify, when you initialize a database connection,
#   a base directory where memo/blob fields will be stored.
# * Changed the way indexes are handled by KBTable in client/server mode.
#   Now, when KBTable grabs an index from KBEngine, it will hold onto it and
#   re-use it unless it has been modified since the last time it grabbed it.
#   This speeds up subsequent queries on the same index.
# * Removed the restriction that the child table had to exist before you
#   could define a Link_many field in #create_table.  I did this so that
#   it would possible to now define many-to-many links.  See the example in
#   the distribution.  This also goes for Lookup fields.
# * Added two sample scripts:  kbserverctl.rb and kbserver_daemon.rb, that
#   show how to set up a KirbyBase server process as a Windows Service.
#   Thanks to Daniel Berger for his excellent package, win32-service.
# * Thouroughly revised the manual.  I used the excellent text document
#   formatter, AsciiDoc.  Many thanks to Stuart Rackham for developing this
#   great tool.
# * Fixed a bug in KBTable#clear that was causing the recno counter not to
#   be reset.  Thanks to basi for this.
#
# 2005-12-01:: Version 2.5
# * Fixed a subtle bug in KBTable#create_indexes.
# * Added the following new methods to KBTable:  add_index, drop_index,
#   rename_column, change_column_type, change_column_default_value, and
#   change_column_required.
# * Added the ability to specify a default column value at table creation
#   time.
# * Added the ability to specify, at table creation time, that a column
#   value is required when inserting or updating records.
# * Removed #add_table_column and #drop_table_column from KirbyBase class
#   and added #add_column and #drop_column to KBTable class.  I felt like
#   it made more sense to have these methods in the table's class rather
#   than the database's class.
# * Added KirbyBase#rename_table method.
# * Added the ability to, upon database initialization, specify that index
#   creation should not happen until a table is actually opened.  This
#   speeds up database initialization at the cost of slower table
#   initialization later.
#
# 2005-12-28:: Version 2.5.1
# * Fixed a bug that had broken encrypted tables.
# * Changed KBTable#pack method so that it raises an error if trying to
#   execute when :connect_type==:client.
# * Fixed a bug where it was possible to insert records missing a required
#   field if using a hash.  Thanks to Adam Shelly for this.
# * Fixed a bug that occurred when you tried to update records using a
#   block and you tried to reference a field in the current record inside
#   the block.  Much thanks to Assaph Mehr for reporting this.
# * Fixed a bug that allowed you to have duplicate column names.  Thanks to
#   Assaph Mehr for spotting this.
# * Changed the way KBTable#set works with memo/blob fields.
# * Started creating unit tests.
# * Changed the KBTable#clear method to return number of records deleted.
#   Thanks to Assaph Mehr for this enhancement.
# * Moved #build_header_string from KBEngine class to KirbyBase class.
# * Added KirbyBase::VERSION constant.
#
# 2005-12-30:: Version 2.5.2
# * Changed the behavior of KBTable#insert method.  If user explicitly
#   specifies nil for a field value and there is a default value for that
#   field, the default value will no longer override the user specified nil
#   value.  Thanks to Assaph Mehr for suggesting this.
#
# 2006-06-27:: Version 2.6
# * Removed NilClass#method_missing.  I have replaced it with a new class
#   called KBNilClass.  Thanks to a host of people for help on this,
#   including:  Assaph Mehr, James Edward Gray II, Matthew Desmarais,
#   Logan Capaldo, Trans, John Carter, Dave Burt and anyone else I missed.
# * Added conditional require logic so that KirbyBase will use FasterCVS if
#   it is available.  Thanks to James Edward Gray II for this.
# * You can now delay index creation in local mode.  Thanks to Nicholas Rahn
#   for this.
# * Added ability to allow for a custom record class with no kb_create or
#   kb_defaults methods.  KirbyBase will return each result record as an
#   instance of the custom record class, and will attempt to set attributes
#   with the same names as the table's field names equal to the values of
#   the table record's fields.  Thanks to Hal Fulton for this idea.
#
#---------------------------------------------------------------------------
# KBTypeConversionsMixin
#---------------------------------------------------------------------------
module KBTypeConversionsMixin
    # Constant that will represent a kb_nil in the physical table file.
    # If you think you might need to write the value 'kb_nil' to a field
    # yourself, comment out the following line and un-comment the line
    # below that to use an alternative representation for kb_nil.
    KB_NIL = 'kb_nil'
    #KB_NIL = '&kb_nil;'

    # Regular expression used to determine if field needs to be un-encoded.
    UNENCODE_RE = /&(?:amp|linefeed|carriage_return|pipe);/

    # Regular expression used to determine if field needs to be encoded.
    ENCODE_RE = /&|\n|\r|\|/

    #-----------------------------------------------------------------------
    # convert_to_native_type
    #-----------------------------------------------------------------------
    #++
    # Return value converted from storage string to native field type.
    #
    def convert_to_native_type(data_type, s)
        return kb_nil if s == KB_NIL

        # I added this line to keep KBTable#import_csv working after I made
        # the kb_nil changes.
        return nil if s.nil?

        case data_type
        when :String
            if s =~ UNENCODE_RE
                return s.gsub('&linefeed;', "\n").gsub('&carriage_return;',
                 "\r").gsub('&substitute;', "\032").gsub('&pipe;', "|"
                 ).gsub('&amp;', "&")
            else
                return s
            end
        when :Integer
            return s.to_i
        when :Float
            return s.to_f
        when :Boolean
            if ['false', 'False', nil, false].include?(s)
                return false
            else
                return true
            end
        when :Time
            return Time.parse(s)    
        when :Date
            return Date.parse(s)
        when :DateTime
            return DateTime.parse(s)
        when :YAML
            # This code is here in case the YAML field is the last
            # field in the record.  Because YAML normally defines a
            # nil value as "--- ", but KirbyBase strips trailing
            # spaces off the end of the record, so if this is the
            # last field in the record, KirbyBase will strip the
            # trailing space off and make it "---".  When KirbyBase
            # attempts to convert this value back using to_yaml,
            # you get an exception.
            if s == "---"
                return nil
            elsif s =~ UNENCODE_RE
                y = s.gsub('&linefeed;', "\n").gsub('&carriage_return;',
                 "\r").gsub('&substitute;', "\032").gsub('&pipe;', "|"
                 ).gsub('&amp;', "&")
                return YAML.load(y)
            else
                return YAML.load(s)
            end
        when :Memo
            memo = KBMemo.new(@tbl.db, s)
            memo.read_from_file
            return memo
        when :Blob
            blob = KBBlob.new(@tbl.db, s)
            blob.read_from_file
            return blob
        else
            raise "Invalid field type: %s" % data_type
        end
    end

    #-----------------------------------------------------------------------
    # convert_to_encoded_string
    #-----------------------------------------------------------------------
    #++
    # Return value converted to encoded String object suitable for storage.
    #
    def convert_to_encoded_string(data_type, value)
        return KB_NIL if value.nil?

        case data_type
        when :YAML
            y = value.to_yaml
            if y =~ ENCODE_RE
                return y.gsub("&", '&amp;').gsub("\n", '&linefeed;').gsub(
                 "\r", '&carriage_return;').gsub("\032", '&substitute;'
                 ).gsub("|", '&pipe;')
            else
                return y
            end
        when :String
            if value =~ ENCODE_RE
                return value.gsub("&", '&amp;').gsub("\n", '&linefeed;'
                 ).gsub("\r", '&carriage_return;').gsub("\032",
                 '&substitute;').gsub("|", '&pipe;')
            else
                return value
            end  
        when :Memo
            return value.filepath
        when :Blob
            return value.filepath
        else
            return value.to_s
        end
    end
end


#---------------------------------------------------------------------------
# KBEncryptionMixin
#---------------------------------------------------------------------------
module KBEncryptionMixin
    EN_STR = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ' + \
     '0123456789.+-,$:|&;_ '
    EN_STR_LEN = EN_STR.length
    EN_KEY1 = ")2VER8GE\"87-E\n"           #*** DO NOT CHANGE ***
    EN_KEY = EN_KEY1.unpack("u")[0]
    EN_KEY_LEN = EN_KEY.length


    #-----------------------------------------------------------------------
    # encrypt_str
    #-----------------------------------------------------------------------
    #++
    # Returns an encrypted string, using the Vignere Cipher.
    #
    def encrypt_str(s)
        new_str = ''
        i_key = -1
        s.each_byte do |c|
            if i_key < EN_KEY_LEN - 1
                i_key += 1
            else
                i_key = 0
            end

            if EN_STR.index(c.chr).nil?
                new_str << c.chr
                next
            end

            i_from_str = EN_STR.index(EN_KEY[i_key]) + EN_STR.index(c.chr)
            i_from_str = i_from_str - EN_STR_LEN if i_from_str >= EN_STR_LEN
            new_str << EN_STR[i_from_str]
        end
        return new_str
    end

    #-----------------------------------------------------------------------
    # unencrypt_str
    #-----------------------------------------------------------------------
    #++
    # Returns an unencrypted string, using the Vignere Cipher.
    #
    def unencrypt_str(s)
        new_str = ''
        i_key = -1
        s.each_byte do |c|
            if i_key < EN_KEY_LEN - 1
                i_key += 1
            else
                i_key = 0
            end

            if EN_STR.index(c.chr).nil?
                new_str << c.chr
                next
            end

            i_from_str = EN_STR.index(c.chr) - EN_STR.index(EN_KEY[i_key])
            i_from_str = i_from_str + EN_STR_LEN if i_from_str < 0
            new_str << EN_STR[i_from_str]
        end
        return new_str
    end
end


#---------------------------------------------------------------------------
# KirbyBase
#---------------------------------------------------------------------------
class KirbyBase
    include DRb::DRbUndumped
    include KBTypeConversionsMixin

    VERSION = "2.6"

    attr_reader :engine

    attr_accessor(:connect_type, :host, :port, :path, :ext, :memo_blob_path,
     :delay_index_creation)

    #-----------------------------------------------------------------------
    # initialize
    #-----------------------------------------------------------------------
    #++
    # Create a new database instance.
    #
    # *connect_type*:: Symbol (:local, :client, :server) specifying role to
    #                  play.
    # *host*:: String containing IP address or DNS name of server hosting
    #          database. (Only valid if connect_type is :client.)
    # *port*:: Integer specifying port database server is listening on.
    #          (Only valid if connect_type is :client.)
    # *path*:: String specifying path to location of database tables.
    # *ext*:: String specifying extension of table files.
    # *memo_blob_path*:: String specifying path to location of memo/blob
    #                    files.
    # *delay_index_creation*:: Boolean specifying whether to delay index
    #                          creation for each table until that table is
    #                          requested by user.
    def initialize(connect_type=:local, host=nil, port=nil, path='./',
     ext='.tbl', memo_blob_path='./', delay_index_creation=false)
        @connect_type = connect_type
        @host = host
        @port = port
        @path = path
        @ext = ext
        @memo_blob_path = memo_blob_path
        @delay_index_creation = delay_index_creation

        # See if user specified any method arguments via a code block.
        yield self if block_given?

        # After the yield, make sure the user doesn't change any of these
        # instance variables.
        class << self
            private(:connect_type=, :host=, :path=, :ext=, :memo_blob_path=,
             :delay_index_creation=)
        end

        # Did user supply full and correct arguments to method?
        raise ArgumentError, 'Invalid connection type specified' unless (
         [:local, :client, :server].include?(@connect_type))
        raise "Must specify hostname or IP address!" if \
         @connect_type == :client and @host.nil?
        raise "Must specify port number!" if @connect_type == :client and \
         @port.nil?
        raise "Invalid path!" if @path.nil?
        raise "Invalid extension!" if @ext.nil?
        raise "Invalid memo/blob path!" if @memo_blob_path.nil?

        @table_hash = {}

        # If running as a client, start druby and connect to server.
        if client?
            DRb.start_service()
            @server = DRbObject.new(nil, 'druby://%s:%d' % [@host, @port])
            @engine = @server.engine
            @path = @server.path
            @ext = @server.ext
            @memo_blob_path = @server.memo_blob_path
        else
            @engine = KBEngine.create_called_from_database_instance(self)
        end

        # The reason why I create all the table instances here is two
        # reasons:  (1) I want all of the tables ready to go when a user
        # does a #get_table, so they don't have to wait for the instance
        # to be created, and (2) I want all of the table indexes to get
        # created at the beginning during database initialization so that
        # they are ready for the user to use.  Since index creation
        # happens when the table instance is first created, I go ahead and
        # create table instances right off the bat.
        #
        # You can delay index creation until the first time the index is
        # used.
        if @delay_index_creation
        else    
            @engine.tables.each do |tbl|
                @table_hash[tbl] = \
                 KBTable.create_called_from_database_instance(self, tbl,
                 File.join(@path, tbl.to_s + @ext))
            end    
        end
    end

    #-----------------------------------------------------------------------
    # server?
    #-----------------------------------------------------------------------
    #++
    # Is this running as a server?
    #
    def server?
        @connect_type == :server
    end

    #-----------------------------------------------------------------------
    # client?
    #-----------------------------------------------------------------------
    #++
    # Is this running as a client?
    #
    def client?
        @connect_type == :client
    end

    #-----------------------------------------------------------------------
    # local?
    #-----------------------------------------------------------------------
    #++
    # Is this running in single-user, embedded mode?
    #
    def local?
        @connect_type == :local
    end

    #-----------------------------------------------------------------------
    # tables
    #-----------------------------------------------------------------------
    #++
    # Return an array containing the names of all tables in this database.
    #
    def tables
        return @engine.tables
    end

    #-----------------------------------------------------------------------
    # get_table
    #-----------------------------------------------------------------------
    #++
    # Return a reference to the requested table.
    # *name*:: Symbol of table name.
    #
    def get_table(name)
        raise('Do not call this method from a server instance!') if server?
        raise(ArgumentError, 'Table name must be a symbol!') unless \
         name.is_a?(Symbol)
        raise('Table not found!') unless table_exists?(name)

        if @table_hash.has_key?(name)
            return @table_hash[name]
        else
            @table_hash[name] = \
             KBTable.create_called_from_database_instance(self, name, 
              File.join(@path, name.to_s + @ext))
            return @table_hash[name]
        end
    end

    #-----------------------------------------------------------------------
    # create_table
    #-----------------------------------------------------------------------
    #++
    # Create new table and return a reference to the new table.
    # *name*:: Symbol of table name.
    # *field_defs*:: List of field names (Symbols), field types (Symbols),
    #                field indexes, and field extras (Indexes, Lookups,
    #                Link_manys, Calculateds, etc.)
    # *Block*:: Optional code block allowing you to set the following:
    # *encrypt*:: true/false specifying whether table should be encrypted.
    # *record_class*:: Class or String specifying the user create class that
    #                  will be associated with table records.
    #
    def create_table(name=nil, *field_defs)
        raise "Can't call #create_table from server!" if server?

        t_struct = Struct.new(:name, :field_defs, :encrypt, :record_class)
        t = t_struct.new
        t.name = name
        t.field_defs = field_defs
        t.encrypt = false
        t.record_class = 'Struct'

        yield t if block_given?

        raise "Name must be a symbol!" unless t.name.is_a?(Symbol)
        raise "No table name specified!" if t.name.nil?
        raise "No table field definitions specified!" if t.field_defs.nil?

        # Can't create a table that already exists!
        raise "Table already exists!" if table_exists?(t.name)

        raise 'Must have a field type for each field name' \
         unless t.field_defs.size.remainder(2) == 0

        # Check to make sure there are no duplicate field names.
        temp_field_names = []
        (0...t.field_defs.size).step(2) do |x|
            temp_field_names << t.field_defs[x]
        end
        raise 'Duplicate field names are not allowed!' unless \
         temp_field_names == temp_field_names.uniq
            
        temp_field_defs = []
        (0...t.field_defs.size).step(2) do |x|
            temp_field_defs << build_header_field_string(t.field_defs[x],
             t.field_defs[x+1])
        end

        @engine.new_table(t.name, temp_field_defs, t.encrypt,
         t.record_class.to_s)

        return get_table(t.name)
    end

    #-----------------------------------------------------------------------
    # build_header_field_string
    #-----------------------------------------------------------------------
    def build_header_field_string(field_name_def, field_type_def)
        # Put field name at start of string definition.
        temp_field_def = field_name_def.to_s + ':'

        # If field type is a hash, that means that it is not just a
        # simple field.  Either is is a key field, it is being used in an
        # index, it is a default value, it is a required field, it is a
        # Lookup field, it is a Link_many field, or it is a Calculated
        # field.  This next bit of code is to piece together a proper
        # string so that it can be written out to the header rec.
        if field_type_def.is_a?(Hash)
            raise 'Missing :DataType key in field_type hash!' unless \
             field_type_def.has_key?(:DataType)

            temp_type = field_type_def[:DataType]

            raise 'Invalid field type: %s' % temp_type unless \
             KBTable.valid_field_type?(temp_type)

            temp_field_def += field_type_def[:DataType].to_s

            # Check if this field is a key for the table.
            if field_type_def.has_key?(:Key)
                temp_field_def += ':Key->true'
            end
            
            # Check for Index definition.
            if field_type_def.has_key?(:Index)
                raise 'Invalid field type for index: %s' % temp_type \
                 unless KBTable.valid_index_type?(temp_type)    

                temp_field_def += ':Index->' + field_type_def[:Index].to_s
            end
                 
            # Check for Default value definition.
            if field_type_def.has_key?(:Default)
                raise 'Cannot set default value for this type: ' + \
                 '%s' % temp_type unless KBTable.valid_default_type?(
                 temp_type)
                
                unless field_type_def[:Default].nil?
                    raise 'Invalid default value ' + \
                     '%s for column %s' % [field_type_def[:Default],
                     field_name_def] unless KBTable.valid_data_type?(
                     temp_type, field_type_def[:Default])

                    temp_field_def += ':Default->' + \
                     convert_to_encoded_string(temp_type,
                     field_type_def[:Default])
                end    
            end
            
            # Check for Required definition.
            if field_type_def.has_key?(:Required)
                raise 'Required must be true or false!' unless \
                 [true, false].include?(field_type_def[:Required])
                
                temp_field_def += \
                 ':Required->%s' % field_type_def[:Required]
            end
            
            # Check for Lookup field, Link_many field, Calculated field
            # definition.
            if field_type_def.has_key?(:Lookup)
                if field_type_def[:Lookup].is_a?(Array)
                    temp_field_def += \
                     ':Lookup->%s.%s' % field_type_def[:Lookup]
                else
                    tbl = get_table(field_type_def[:Lookup])
                    temp_field_def += \
                     ':Lookup->%s.%s' % [field_type_def[:Lookup],
                     tbl.lookup_key]
                end
            elsif field_type_def.has_key?(:Link_many)
                raise 'Field type for Link_many field must be :ResultSet' \
                 unless temp_type == :ResultSet
                temp_field_def += \
                 ':Link_many->%s=%s.%s' % field_type_def[:Link_many]
            elsif field_type_def.has_key?(:Calculated)
                temp_field_def += \
                 ':Calculated->%s' % field_type_def[:Calculated]
            end
        else
            if KBTable.valid_field_type?(field_type_def)
                temp_field_def += field_type_def.to_s
            elsif table_exists?(field_type_def)
                tbl = get_table(field_type_def)
                temp_field_def += \
                 '%s:Lookup->%s.%s' % [tbl.field_types[
                 tbl.field_names.index(tbl.lookup_key)], field_type_def,
                 tbl.lookup_key]
            else
                raise 'Invalid field type: %s' % field_type_def
            end
        end
        return temp_field_def
    end

    #-----------------------------------------------------------------------
    # rename_table
    #-----------------------------------------------------------------------
    #++
    # Rename a table.
    #
    # *old_tablename*:: Symbol of old table name.
    # *new_tablename*:: Symbol of new table name.
    #
    def rename_table(old_tablename, new_tablename)
        raise "Cannot rename table running in client mode!" if client?
        raise "Table does not exist!" unless table_exists?(old_tablename)
        raise(ArgumentError, 'Existing table name must be a symbol!') \
         unless old_tablename.is_a?(Symbol)
        raise(ArgumentError, 'New table name must be a symbol!') unless \
         new_tablename.is_a?(Symbol)
        raise "Table already exists!" if table_exists?(new_tablename)

        @table_hash.delete(old_tablename)
        @engine.rename_table(old_tablename, new_tablename)
        get_table(new_tablename)
    end

    #-----------------------------------------------------------------------
    # drop_table
    #-----------------------------------------------------------------------
    #++
    # Delete a table.
    #
    # *tablename*:: Symbol of table name.
    #
    def drop_table(tablename)
        raise(ArgumentError, 'Table name must be a symbol!') unless \
         tablename.is_a?(Symbol)
        raise "Table does not exist!" unless table_exists?(tablename)
        @table_hash.delete(tablename)

        return @engine.delete_table(tablename)
    end

    #-----------------------------------------------------------------------
    # table_exists?
    #-----------------------------------------------------------------------
    #++
    # Return true if table exists.
    #
    # *tablename*:: Symbol of table name.
    #
    def table_exists?(tablename)
        raise(ArgumentError, 'Table name must be a symbol!') unless \
         tablename.is_a?(Symbol)

        return @engine.table_exists?(tablename)
    end

end


#---------------------------------------------------------------------------
# KBEngine
#---------------------------------------------------------------------------
class KBEngine
    include DRb::DRbUndumped
    include KBTypeConversionsMixin
    include KBEncryptionMixin

    # Make constructor private.
    private_class_method :new

    #-----------------------------------------------------------------------
    # KBEngine.create_called_from_database_instance
    #-----------------------------------------------------------------------
    def KBEngine.create_called_from_database_instance(db)
        return new(db)
    end

    #-----------------------------------------------------------------------
    # initialize
    #-----------------------------------------------------------------------
    def initialize(db)
        @db = db
        @recno_indexes = {}
        @indexes = {}

        # This hash will hold the table locks if in client/server mode.
        @mutex_hash = {} if @db.server?
    end

    #-----------------------------------------------------------------------
    # init_recno_index
    #-----------------------------------------------------------------------
    def init_recno_index(table)
        return if recno_index_exists?(table)

        with_write_locked_table(table) do |fptr|
            @recno_indexes[table.name] = KBRecnoIndex.new(table)
            @recno_indexes[table.name].rebuild(fptr)
        end
    end

    #-----------------------------------------------------------------------
    # rebuild_recno_index
    #-----------------------------------------------------------------------
    def rebuild_recno_index(table)
        with_write_locked_table(table) do |fptr|
            @recno_indexes[table.name].rebuild(fptr)
        end
    end

    #-----------------------------------------------------------------------
    # remove_recno_index
    #-----------------------------------------------------------------------
    def remove_recno_index(tablename)
        @recno_indexes.delete(tablename)
    end

    #-----------------------------------------------------------------------
    # update_recno_index
    #-----------------------------------------------------------------------
    def update_recno_index(table, recno, fpos)
        @recno_indexes[table.name].update_index_rec(recno, fpos)
    end

    #-----------------------------------------------------------------------
    # recno_index_exists?
    #-----------------------------------------------------------------------
    def recno_index_exists?(table)
        @recno_indexes.include?(table.name)
    end

    #-----------------------------------------------------------------------
    # get_recno_index
    #-----------------------------------------------------------------------
    def get_recno_index(table)
        return @recno_indexes[table.name].get_idx
    end

    #-----------------------------------------------------------------------
    # init_index
    #-----------------------------------------------------------------------
    def init_index(table, index_fields)
        return if index_exists?(table, index_fields)

        with_write_locked_table(table) do |fptr|
            @indexes["#{table.name}_#{index_fields.join('_')}".to_sym] = \
             KBIndex.new(table, index_fields)
            @indexes["#{table.name}_#{index_fields.join('_')}".to_sym
             ].rebuild(fptr)
        end
    end

    #-----------------------------------------------------------------------
    # rebuild_index
    #-----------------------------------------------------------------------
    def rebuild_index(table, index_fields)
        with_write_locked_table(table) do |fptr|
            @indexes["#{table.name}_#{index_fields.join('_')}".to_sym
             ].rebuild(fptr)
        end
    end

    #-----------------------------------------------------------------------
    # remove_indexes
    #-----------------------------------------------------------------------
    def remove_indexes(tablename)
        re_table_name = Regexp.new(tablename.to_s)
        @indexes.delete_if { |k,v| k.to_s =~ re_table_name }
    end

    #-----------------------------------------------------------------------
    # add_to_indexes
    #-----------------------------------------------------------------------
    def add_to_indexes(table, rec, fpos)
        @recno_indexes[table.name].add_index_rec(rec.first, fpos)

        re_table_name = Regexp.new(table.name.to_s)
        @indexes.each_pair do |key, index|
            index.add_index_rec(rec) if key.to_s =~ re_table_name
        end
    end

    #-----------------------------------------------------------------------
    # delete_from_indexes
    #-----------------------------------------------------------------------
    def delete_from_indexes(table, rec, fpos)
        @recno_indexes[table.name].delete_index_rec(rec.recno)

        re_table_name = Regexp.new(table.name.to_s)
        @indexes.each_pair do |key, index|
            index.delete_index_rec(rec.recno) if key.to_s =~ re_table_name
        end
    end

    #-----------------------------------------------------------------------
    # update_to_indexes
    #-----------------------------------------------------------------------
    def update_to_indexes(table, rec)
        re_table_name = Regexp.new(table.name.to_s)
        @indexes.each_pair do |key, index|
            index.update_index_rec(rec) if key.to_s =~ re_table_name
        end
    end

    #-----------------------------------------------------------------------
    # index_exists?
    #-----------------------------------------------------------------------
    def index_exists?(table, index_fields)
        @indexes.include?("#{table.name}_#{index_fields.join('_')}".to_sym)
    end

    #-----------------------------------------------------------------------
    # get_index
    #-----------------------------------------------------------------------
    def get_index(table, index_name)
        return @indexes["#{table.name}_#{index_name}".to_sym].get_idx
    end

    #-----------------------------------------------------------------------
    # get_index_timestamp
    #-----------------------------------------------------------------------
    def get_index_timestamp(table, index_name)
        return @indexes["#{table.name}_#{index_name}".to_sym].get_timestamp
    end

    #-----------------------------------------------------------------------
    # table_exists?
    #-----------------------------------------------------------------------
    def table_exists?(tablename)
        return File.exists?(File.join(@db.path, tablename.to_s + @db.ext))
    end

    #-----------------------------------------------------------------------
    # tables
    #-----------------------------------------------------------------------
    def tables
        list = []
        Dir.foreach(@db.path) { |filename|
            list << File.basename(filename, '.*').to_sym if \
             File.extname(filename) == @db.ext
        }
        return list
    end

    #-----------------------------------------------------------------------
    # new_table
    #-----------------------------------------------------------------------
    #++
    # Create physical file holding table. This table should not be directly
    # called in your application, but only called by #create_table.
    #
    def new_table(name, field_defs, encrypt, record_class)
        # Header rec consists of last record no. used, delete count, and
        # all field names/types.  Here, I am inserting the 'recno' field
        # at the beginning of the fields.
        header_rec = ['000000', '000000', record_class, 'recno:Integer',
         field_defs].join('|')

        header_rec = 'Z' + encrypt_str(header_rec) if encrypt

        begin
            fptr = open(File.join(@db.path, name.to_s + @db.ext), 'w')
            fptr.write(header_rec + "\n")
        ensure
            fptr.close
        end
    end

    #-----------------------------------------------------------------------
    # delete_table
    #-----------------------------------------------------------------------
    def delete_table(tablename)
        with_write_lock(tablename) do
            File.delete(File.join(@db.path, tablename.to_s + @db.ext))
            remove_indexes(tablename)
            remove_recno_index(tablename)
            return true
        end
    end

    #----------------------------------------------------------------------
    # get_total_recs
    #----------------------------------------------------------------------
    def get_total_recs(table)
        return get_recs(table).size
    end

    #-----------------------------------------------------------------------
    # reset_recno_ctr
    #-----------------------------------------------------------------------
    def reset_recno_ctr(table)
        with_write_locked_table(table) do |fptr|
            encrypted, header_line = get_header_record(table, fptr)
            last_rec_no, rest_of_line = header_line.split('|', 2)
            write_header_record(table, fptr, 
             ['%06d' % 0, rest_of_line].join('|'))
            return true
        end
    end

    #-----------------------------------------------------------------------
    # get_header_vars
    #-----------------------------------------------------------------------
    def get_header_vars(table)
        with_table(table) do |fptr|
            encrypted, line = get_header_record(table, fptr)

            last_rec_no, del_ctr, record_class, *flds = line.split('|')
            field_names = flds.collect { |x| x.split(':')[0].to_sym }
            field_types = flds.collect { |x| x.split(':')[1].to_sym }
            field_indexes = [nil] * field_names.size
            field_defaults = [nil] * field_names.size
            field_requireds = [false] * field_names.size
            field_extras = [nil] * field_names.size

            flds.each_with_index do |x,i|
                field_extras[i] = {}
                if x.split(':').size > 2
                    x.split(':')[2..-1].each do |y|
                        if y =~ /Index/
                            field_indexes[i] = y
                        elsif y =~ /Default/
                            field_defaults[i] = \
                             convert_to_native_type(field_types[i],
                              y.split('->')[1])
                        elsif y =~ /Required/
                            field_requireds[i] = \
                             convert_to_native_type(:Boolean,
                              y.split('->')[1])
                        else
                            field_extras[i][y.split('->')[0]] = \
                             y.split('->')[1]
                        end
                    end
                end
            end
            return [encrypted, last_rec_no.to_i, del_ctr.to_i,
             record_class, field_names, field_types, field_indexes,
             field_defaults, field_requireds, field_extras]
        end
    end

    #-----------------------------------------------------------------------
    # get_recs
    #-----------------------------------------------------------------------
    def get_recs(table)
        encrypted = table.encrypted?
        recs = []

        with_table(table) do |fptr|
            begin
                # Skip header rec.
                fptr.readline

                # Loop through table.
                while true
                    # Record current position in table.
                    fpos = fptr.tell
                    rec, line_length = line_to_rec(fptr.readline, encrypted)

                    next if rec.empty?

                    rec << fpos << line_length
                    recs << rec
                end
            # Here's how we break out of the loop...
            rescue EOFError
            end
            return recs
        end
    end

    #-----------------------------------------------------------------------
    # get_recs_by_recno
    #-----------------------------------------------------------------------
    def get_recs_by_recno(table, recnos)
        encrypted = table.encrypted?
        recs = []
        recno_idx = get_recno_index(table)

        with_table(table) do |fptr|
            # Skip header rec.
            fptr.readline

            # Take all the recnos you want to get, add the file positions
            # to them, and sort by file position, so that when we seek 
            # through the physical file we are going in ascending file
            # position order, which should be fastest.
            recnos.collect { |r| [recno_idx[r], r] }.sort.each do |r|
                fptr.seek(r[0])
                rec, line_length = line_to_rec(fptr.readline, encrypted)

                next if rec.empty?

                raise "Index Corrupt!" unless rec[0].to_i == r[1]
                rec << r[0] << line_length
                recs << rec
            end
            return recs
        end
    end

    #-----------------------------------------------------------------------
    # get_rec_by_recno
    #-----------------------------------------------------------------------
    def get_rec_by_recno(table, recno)
        encrypted = table.encrypted?
        recno_idx = get_recno_index(table)

        return nil unless recno_idx.has_key?(recno)

        with_table(table) do |fptr|
            fptr.seek(recno_idx[recno])
            rec, line_length = line_to_rec(fptr.readline, encrypted)

            raise "Recno Index Corrupt for table %s!" % table.name if \
             rec.empty?

            raise "Recno Index Corrupt for table %s!" % table.name unless \
             rec[0].to_i == recno

            rec << recno_idx[recno] << line_length
            return rec
        end
    end

    #-----------------------------------------------------------------------
    # line_to_rec
    #-----------------------------------------------------------------------
    def line_to_rec(line, encrypted)
        line.chomp!
        line_length = line.length
        line = unencrypt_str(line) if encrypted
        line.strip!

        # Convert line to rec and return rec and line length.
        return line.split('|', -1), line_length
    end

    #-----------------------------------------------------------------------
    # insert_record
    #-----------------------------------------------------------------------
    def insert_record(table, rec)
        with_write_locked_table(table) do |fptr|
            # Auto-increment the record number field.
            rec_no = incr_rec_no_ctr(table, fptr)

            # Insert the newly created record number value at the beginning
            # of the field values.
            rec[0] = rec_no

            fptr.seek(0, IO::SEEK_END)
            fpos = fptr.tell

            write_record(table, fptr, 'end', rec.join('|'))

            add_to_indexes(table, rec, fpos)

            # Return the record number of the newly created record.
            return rec_no
        end
    end

    #-----------------------------------------------------------------------
    # update_records
    #-----------------------------------------------------------------------
    def update_records(table, recs)
        with_write_locked_table(table) do |fptr|
            recs.each do |rec|
                line = rec[:rec].join('|')

                # This doesn't actually 'delete' the line, it just
                # makes it all spaces.  That way, if the updated
                # record is the same or less length than the old
                # record, we can write the record back into the
                # same spot.  If the updated record is greater than
                # the old record, we will leave the now spaced-out
                # line and write the updated record at the end of
                # the file.
                write_record(table, fptr, rec[:fpos],
                 ' ' * rec[:line_length])
                if line.length > rec[:line_length]
                    fptr.seek(0, IO::SEEK_END)
                    new_fpos = fptr.tell
                    write_record(table, fptr, 'end', line)
                    incr_del_ctr(table, fptr)

                    update_recno_index(table, rec[:rec].first, new_fpos)
                else
                    write_record(table, fptr, rec[:fpos], line)
                end
                update_to_indexes(table, rec[:rec])
            end
            # Return the number of records updated.
            return recs.size
        end
    end

    #-----------------------------------------------------------------------
    # delete_records
    #-----------------------------------------------------------------------
    def delete_records(table, recs)
        with_write_locked_table(table) do |fptr|
            recs.each do |rec|
                # Go to offset within the file where the record is and
                # replace it with all spaces.
                write_record(table, fptr, rec.fpos, ' ' * rec.line_length)
                incr_del_ctr(table, fptr)

                delete_from_indexes(table, rec, rec.fpos)
            end

            # Return the number of records deleted.
            return recs.size
        end
    end

    #-----------------------------------------------------------------------
    # change_column_type
    #-----------------------------------------------------------------------
    def change_column_type(table, col_name, col_type)
        col_index = table.field_names.index(col_name)
        with_write_lock(table.name) do
            fptr = open(table.filename, 'r')
            new_fptr = open(table.filename+'temp', 'w')

            line = fptr.readline.chomp

            if line[0..0] == 'Z'
                header_rec = unencrypt_str(line[1..-1]).split('|')
            else
                header_rec = line.split('|')
            end
            
            temp_fields = header_rec[col_index+3].split(':')
            temp_fields[1] = col_type.to_s
            header_rec[col_index+3] = temp_fields.join(':')

            if line[0..0] == 'Z'
                new_fptr.write('Z' + encrypt_str(header_rec.join('|')) +
                 "\n")
            else
                new_fptr.write(header_rec.join('|') + "\n")
            end

            begin
                while true
                    new_fptr.write(fptr.readline)
                end
            # Here's how we break out of the loop...
            rescue EOFError
            end

            # Close the table and release the write lock.
            fptr.close
            new_fptr.close
            File.delete(table.filename)
            FileUtils.mv(table.filename+'temp', table.filename)
        end
    end

    #-----------------------------------------------------------------------
    # rename_column
    #-----------------------------------------------------------------------
    def rename_column(table, old_col_name, new_col_name)
        col_index = table.field_names.index(old_col_name)
        with_write_lock(table.name) do
            fptr = open(table.filename, 'r')
            new_fptr = open(table.filename+'temp', 'w')

            line = fptr.readline.chomp

            if line[0..0] == 'Z'
                header_rec = unencrypt_str(line[1..-1]).split('|')
            else
                header_rec = line.split('|')
            end
            
            temp_fields = header_rec[col_index+3].split(':')
            temp_fields[0] = new_col_name.to_s
            header_rec[col_index+3] = temp_fields.join(':')

            if line[0..0] == 'Z'
                new_fptr.write('Z' + encrypt_str(header_rec.join('|')) +
                 "\n")
            else
                new_fptr.write(header_rec.join('|') + "\n")
            end

            begin
                while true
                    new_fptr.write(fptr.readline)
                end
            # Here's how we break out of the loop...
            rescue EOFError
            end

            # Close the table and release the write lock.
            fptr.close
            new_fptr.close
            File.delete(table.filename)
            FileUtils.mv(table.filename+'temp', table.filename)
        end
    end

    #-----------------------------------------------------------------------
    # add_column
    #-----------------------------------------------------------------------
    def add_column(table, field_def, after)
        # Find the index position of where to insert the column, either at
        # the end (-1) or after the field specified.
        if after.nil? or table.field_names.last == after
            insert_after = -1
        else
            insert_after = table.field_names.index(after)+1
        end

        with_write_lock(table.name) do
            fptr = open(table.filename, 'r')
            new_fptr = open(table.filename+'temp', 'w')

            line = fptr.readline.chomp

            if line[0..0] == 'Z'
                header_rec = unencrypt_str(line[1..-1]).split('|')
            else
                header_rec = line.split('|')
            end

            if insert_after == -1
                header_rec.insert(insert_after, field_def)
            else
                # Need to account for recno ctr, delete ctr, record class.
                header_rec.insert(insert_after+3, field_def)
            end

            if line[0..0] == 'Z'
                new_fptr.write('Z' + encrypt_str(header_rec.join('|')) +
                 "\n")
            else
                new_fptr.write(header_rec.join('|') + "\n")
            end

            begin
                while true
                    line = fptr.readline.chomp

                    if table.encrypted?
                        temp_line = unencrypt_str(line)
                    else
                        temp_line = line
                    end

                    rec = temp_line.split('|', -1)
                    rec.insert(insert_after, '')

                    if table.encrypted?
                        new_fptr.write(encrypt_str(rec.join('|')) + "\n")
                    else
                        new_fptr.write(rec.join('|') + "\n")
                    end
                end
            # Here's how we break out of the loop...
            rescue EOFError
            end

            # Close the table and release the write lock.
            fptr.close
            new_fptr.close
            File.delete(table.filename)
            FileUtils.mv(table.filename+'temp', table.filename)
        end
    end

    #-----------------------------------------------------------------------
    # drop_column
    #-----------------------------------------------------------------------
    def drop_column(table, col_name)
        col_index = table.field_names.index(col_name)
        with_write_lock(table.name) do
            fptr = open(table.filename, 'r')
            new_fptr = open(table.filename+'temp', 'w')

            line = fptr.readline.chomp

            if line[0..0] == 'Z'
                header_rec = unencrypt_str(line[1..-1]).split('|')
                header_rec.delete_at(col_index+3)
                new_fptr.write('Z' + encrypt_str(header_rec.join('|')) +
                 "\n")
            else
                header_rec = line.split('|')
                header_rec.delete_at(col_index+3)
                new_fptr.write(header_rec.join('|') + "\n")
            end

            begin
                while true
                    line = fptr.readline.chomp

                    if table.encrypted?
                        temp_line = unencrypt_str(line)
                    else
                        temp_line = line
                    end

                    rec = temp_line.split('|', -1)
                    rec.delete_at(col_index)

                    if table.encrypted?
                        new_fptr.write(encrypt_str(rec.join('|')) + "\n")
                    else
                        new_fptr.write(rec.join('|') + "\n")
                    end
                end
            # Here's how we break out of the loop...
            rescue EOFError
            end

            # Close the table and release the write lock.
            fptr.close
            new_fptr.close
            File.delete(table.filename)
            FileUtils.mv(table.filename+'temp', table.filename)
        end
    end

    #-----------------------------------------------------------------------
    # rename_table
    #-----------------------------------------------------------------------
    def rename_table(old_tablename, new_tablename)
        old_full_path = File.join(@db.path, old_tablename.to_s + @db.ext)
        new_full_path = File.join(@db.path, new_tablename.to_s + @db.ext)
        File.rename(old_full_path, new_full_path)    
    end
    
    #-----------------------------------------------------------------------
    # add_index
    #-----------------------------------------------------------------------
    def add_index(table, col_names, index_no)
        with_write_lock(table.name) do
            fptr = open(table.filename, 'r')
            new_fptr = open(table.filename+'temp', 'w')

            line = fptr.readline.chomp

            if line[0..0] == 'Z'
                header_rec = unencrypt_str(line[1..-1]).split('|')
            else
                header_rec = line.split('|')
            end
            
            col_names.each do |c|
                header_rec[table.field_names.index(c)+3] += \
                 ':Index->%d' % index_no
            end

            if line[0..0] == 'Z'
                new_fptr.write('Z' + encrypt_str(header_rec.join('|')) +
                 "\n")
            else
                new_fptr.write(header_rec.join('|') + "\n")
            end

            begin
                while true
                    new_fptr.write(fptr.readline)
                end
            # Here's how we break out of the loop...
            rescue EOFError
            end

            # Close the table and release the write lock.
            fptr.close
            new_fptr.close
            File.delete(table.filename)
            FileUtils.mv(table.filename+'temp', table.filename)
        end
    end

    #-----------------------------------------------------------------------
    # drop_index
    #-----------------------------------------------------------------------
    def drop_index(table, col_names)
        with_write_lock(table.name) do
            fptr = open(table.filename, 'r')
            new_fptr = open(table.filename+'temp', 'w')

            line = fptr.readline.chomp

            if line[0..0] == 'Z'
                header_rec = unencrypt_str(line[1..-1]).split('|')
            else
                header_rec = line.split('|')
            end
            
            col_names.each do |c|
                temp_field_def = \
                 header_rec[table.field_names.index(c)+3].split(':')
                temp_field_def = temp_field_def.delete_if {|x|
                    x =~ /Index->/
                }    
                header_rec[table.field_names.index(c)+3] = \
                 temp_field_def.join(':')
            end

            if line[0..0] == 'Z'
                new_fptr.write('Z' + encrypt_str(header_rec.join('|')) +
                 "\n")
            else
                new_fptr.write(header_rec.join('|') + "\n")
            end

            begin
                while true
                    new_fptr.write(fptr.readline)
                end
            # Here's how we break out of the loop...
            rescue EOFError
            end

            # Close the table and release the write lock.
            fptr.close
            new_fptr.close
            File.delete(table.filename)
            FileUtils.mv(table.filename+'temp', table.filename)
        end
    end

    #-----------------------------------------------------------------------
    # change_column_default_value
    #-----------------------------------------------------------------------
    def change_column_default_value(table, col_name, value)
        with_write_lock(table.name) do
            fptr = open(table.filename, 'r')
            new_fptr = open(table.filename+'temp', 'w')

            line = fptr.readline.chomp

            if line[0..0] == 'Z'
                header_rec = unencrypt_str(line[1..-1]).split('|')
            else
                header_rec = line.split('|')
            end
            
            if header_rec[table.field_names.index(col_name)+3] =~ \
             /Default->/
                hr_chunks = \
                 header_rec[table.field_names.index(col_name)+3].split(':')

                if value.nil?
                    hr_chunks = hr_chunks.delete_if { |x| x =~ /Default->/ }
                    header_rec[table.field_names.index(col_name)+3] = \
                     hr_chunks.join(':')
                else
                    hr_chunks.collect! do |x|
                        if x =~ /Default->/
                            'Default->%s' % value
                        else
                            x
                        end
                    end
                    header_rec[table.field_names.index(col_name)+3] = \
                     hr_chunks.join(':')
                end              
            else
                if value.nil?
                else
                    header_rec[table.field_names.index(col_name)+3] += \
                     ':Default->%s' % value
                end    
            end

            if line[0..0] == 'Z'
                new_fptr.write('Z' + encrypt_str(header_rec.join('|')) +
                 "\n")
            else
                new_fptr.write(header_rec.join('|') + "\n")
            end

            begin
                while true
                    new_fptr.write(fptr.readline)
                end
            # Here's how we break out of the loop...
            rescue EOFError
            end

            # Close the table and release the write lock.
            fptr.close
            new_fptr.close
            File.delete(table.filename)
            FileUtils.mv(table.filename+'temp', table.filename)
        end
    end

    #-----------------------------------------------------------------------
    # change_column_required
    #-----------------------------------------------------------------------
    def change_column_required(table, col_name, required)
        with_write_lock(table.name) do
            fptr = open(table.filename, 'r')
            new_fptr = open(table.filename+'temp', 'w')

            line = fptr.readline.chomp

            if line[0..0] == 'Z'
                header_rec = unencrypt_str(line[1..-1]).split('|')
            else
                header_rec = line.split('|')
            end
            
            if header_rec[table.field_names.index(col_name)+3
             ] =~ /Required->/
                hr_chunks = \
                 header_rec[table.field_names.index(col_name)+3].split(':')
                if not required
                    hr_chunks = hr_chunks.delete_if {|x| x =~ /Required->/}
                    header_rec[table.field_names.index(col_name)+3] = \
                     hr_chunks.join(':')
                else
                    hr_chunks.collect! do |x|
                        if x =~ /Required->/
                            'Default->%s' % required
                        else
                            x
                        end
                    end
                    header_rec[table.field_names.index(col_name)+3] = \
                     hr_chunks.join(':')
                end    
            else
                if not required
                else
                    header_rec[table.field_names.index(col_name)+3] += \
                     ':Required->%s' % required
                end    
            end

            if line[0..0] == 'Z'
                new_fptr.write('Z' + encrypt_str(header_rec.join('|')) +
                 "\n")
            else
                new_fptr.write(header_rec.join('|') + "\n")
            end

            begin
                while true
                    new_fptr.write(fptr.readline)
                end
            # Here's how we break out of the loop...
            rescue EOFError
            end

            # Close the table and release the write lock.
            fptr.close
            new_fptr.close
            File.delete(table.filename)
            FileUtils.mv(table.filename+'temp', table.filename)
        end
    end

    #-----------------------------------------------------------------------
    # pack_table
    #-----------------------------------------------------------------------
    def pack_table(table)
        with_write_lock(table.name) do
            fptr = open(table.filename, 'r')
            new_fptr = open(table.filename+'temp', 'w')

            line = fptr.readline.chomp
            # Reset the delete counter in the header rec to 0.
            if line[0..0] == 'Z'
                header_rec = unencrypt_str(line[1..-1]).split('|')
                header_rec[1] = '000000'
                new_fptr.write('Z' + encrypt_str(header_rec.join('|')) +
                 "\n")
            else
                header_rec = line.split('|')
                header_rec[1] = '000000'
                new_fptr.write(header_rec.join('|') + "\n")
            end

            lines_deleted = 0

            begin
                while true
                    line = fptr.readline

                    if table.encrypted?
                        temp_line = unencrypt_str(line)
                    else
                        temp_line = line
                    end

                    if temp_line.strip == ''
                        lines_deleted += 1
                    else
                        new_fptr.write(line)
                    end
                end
            # Here's how we break out of the loop...
            rescue EOFError
            end

            # Close the table and release the write lock.
            fptr.close
            new_fptr.close
            File.delete(table.filename)
            FileUtils.mv(table.filename+'temp', table.filename)

            # Return the number of deleted records that were removed.
            return lines_deleted
        end
    end

    #-----------------------------------------------------------------------
    # read_memo_file
    #-----------------------------------------------------------------------
    def read_memo_file(filepath)
        begin
            f = File.new(File.join(@db.memo_blob_path, filepath))
            return f.read
        ensure
            f.close
        end
    end

    #-----------------------------------------------------------------------
    # write_memo_file
    #-----------------------------------------------------------------------
    def write_memo_file(filepath, contents)
        begin
            f = File.new(File.join(@db.memo_blob_path, filepath), 'w')
            f.write(contents)
        ensure
            f.close
        end
    end

    #-----------------------------------------------------------------------
    # read_blob_file
    #-----------------------------------------------------------------------
    def read_blob_file(filepath)
        begin
            f = File.new(File.join(@db.memo_blob_path, filepath), 'rb')
            return f.read
        ensure
            f.close
        end
    end

    #-----------------------------------------------------------------------
    # write_blob_file
    #-----------------------------------------------------------------------
    def write_blob_file(filepath, contents)
        begin
            f = File.new(File.join(@db.memo_blob_path, filepath), 'wb')
            f.write(contents)
        ensure
            f.close
        end
    end
    

    #-----------------------------------------------------------------------
    # PRIVATE METHODS
    #-----------------------------------------------------------------------
    private

    #-----------------------------------------------------------------------
    # with_table
    #-----------------------------------------------------------------------
    def with_table(table, access='r')
        begin
            yield fptr = open(table.filename, access)
        ensure
            fptr.close
        end
    end

    #-----------------------------------------------------------------------
    # with_write_lock
    #-----------------------------------------------------------------------
    def with_write_lock(tablename)
        begin
            write_lock(tablename) if @db.server?
            yield
        ensure
            write_unlock(tablename) if @db.server?
        end
    end

    #-----------------------------------------------------------------------
    # with_write_locked_table
    #-----------------------------------------------------------------------
    def with_write_locked_table(table, access='r+')
        begin
            write_lock(table.name) if @db.server?
            yield fptr = open(table.filename, access)
        ensure
            fptr.close
            write_unlock(table.name) if @db.server?
        end
    end

    #-----------------------------------------------------------------------
    # write_lock
    #-----------------------------------------------------------------------
    def write_lock(tablename)
        # Unless an key already exists in the hash holding mutex records
        # for this table, create a write key for this table in the mutex
        # hash.  Then, place a lock on that mutex.
        @mutex_hash[tablename] = Mutex.new unless (
         @mutex_hash.has_key?(tablename))
        @mutex_hash[tablename].lock

        return true
    end

    #----------------------------------------------------------------------
    # write_unlock
    #----------------------------------------------------------------------
    def write_unlock(tablename)
        # Unlock the write mutex for this table.
        @mutex_hash[tablename].unlock

        return true
    end

    #----------------------------------------------------------------------
    # write_record
    #----------------------------------------------------------------------
    def write_record(table, fptr, pos, record)
        if table.encrypted?
            temp_rec = encrypt_str(record)
        else
            temp_rec = record
        end

        # If record is to be appended, go to end of table and write
        # record, adding newline character.
        if pos == 'end'
            fptr.seek(0, IO::SEEK_END)
            fptr.write(temp_rec + "\n")
        else
            # Otherwise, overwrite another record (that's why we don't
            # add the newline character).
            fptr.seek(pos)
            fptr.write(temp_rec)
        end
    end

    #----------------------------------------------------------------------
    # write_header_record
    #----------------------------------------------------------------------
    def write_header_record(table, fptr, record)
        fptr.seek(0)

        if table.encrypted?
            fptr.write('Z' + encrypt_str(record) + "\n")
        else
            fptr.write(record + "\n")
        end
    end

    #----------------------------------------------------------------------
    # get_header_record
    #----------------------------------------------------------------------
    def get_header_record(table, fptr)
        fptr.seek(0)

        line = fptr.readline.chomp

        if line[0..0] == 'Z'
            return [true, unencrypt_str(line[1..-1])]
        else
            return [false, line]
        end
    end

    #-----------------------------------------------------------------------
    # incr_rec_no_ctr
    #-----------------------------------------------------------------------
    def incr_rec_no_ctr(table, fptr)
        encrypted, header_line = get_header_record(table, fptr)
        last_rec_no, rest_of_line = header_line.split('|', 2)
        last_rec_no = last_rec_no.to_i + 1

        write_header_record(table, fptr, ['%06d' % last_rec_no,
         rest_of_line].join('|'))

        # Return the new recno.
        return last_rec_no
    end

    #-----------------------------------------------------------------------
    # incr_del_ctr
    #-----------------------------------------------------------------------
    def incr_del_ctr(table, fptr)
        encrypted, header_line = get_header_record(table, fptr)
        last_rec_no, del_ctr, rest_of_line = header_line.split('|', 3)
        del_ctr = del_ctr.to_i + 1

        write_header_record(table, fptr, [last_rec_no, '%06d' % del_ctr,
         rest_of_line].join('|'))

        return true
    end
end


#---------------------------------------------------------------------------
# KBTable
#---------------------------------------------------------------------------
class KBTable
    include DRb::DRbUndumped
    include KBTypeConversionsMixin

    # Make constructor private.  KBTable instances should only be created
    # from KirbyBase#get_table.
    private_class_method :new

    VALID_FIELD_TYPES = [:String, :Integer, :Float, :Boolean, :Date, :Time,
                         :DateTime, :Memo, :Blob, :ResultSet, :YAML]
    VALID_DEFAULT_TYPES = [:String, :Integer, :Float, :Boolean, :Date,
                           :Time, :DateTime, :YAML]
    VALID_INDEX_TYPES = [:String, :Integer, :Float, :Boolean, :Date, :Time,
                         :DateTime]

    attr_reader :filename, :name, :table_class, :db, :lookup_key, \
                           :last_rec_no, :del_ctr

    #-----------------------------------------------------------------------
    # KBTable.valid_field_type?
    #-----------------------------------------------------------------------
    #++
    # Return true if valid field type.
    #
    # *field_type*:: Symbol specifying field type.
    #
    def KBTable.valid_field_type?(field_type)
        VALID_FIELD_TYPES.include?(field_type)
    end

    #-----------------------------------------------------------------------
    # KBTable.valid_data_type?
    #-----------------------------------------------------------------------
    #++
    # Return true if data is correct type, false otherwise.
    #
    # *data_type*:: Symbol specifying data type.
    # *value*:: Value to convert to String.
    #
    def KBTable.valid_data_type?(data_type, value)
        case data_type
        when /:String|:Blob/
            return false unless value.respond_to?(:to_str)
        when :Memo
            return false unless value.is_a?(KBMemo) 
        when :Blob
            return false unless value.is_a?(KBBlob) 
        when :Boolean
            return false unless value.is_a?(TrueClass) or value.is_a?(
             FalseClass)
        when :Integer
            return false unless value.respond_to?(:to_int)
        when :Float
            return false unless value.respond_to?(:to_f)
        when :Time
            return false unless value.is_a?(Time)     
        when :Date
            return false unless value.is_a?(Date)
        when :DateTime
            return false unless value.is_a?(DateTime)
        when :YAML
            return false unless value.respond_to?(:to_yaml)
        end
    
        return true
    end

    #-----------------------------------------------------------------------
    # KBTable.valid_default_type?
    #-----------------------------------------------------------------------
    #++
    # Return true if valid default type.
    #
    # *field_type*:: Symbol specifying field type.
    #
    def KBTable.valid_default_type?(field_type)
        VALID_DEFAULT_TYPES.include?(field_type)
    end

    #-----------------------------------------------------------------------
    # KBTable.valid_index_type?
    #-----------------------------------------------------------------------
    #++
    # Return true if valid index type.
    #
    # *field_type*:: Symbol specifying field type.
    #
    def KBTable.valid_index_type?(field_type)
        VALID_INDEX_TYPES.include?(field_type)
    end

    #-----------------------------------------------------------------------
    # create_called_from_database_instance
    #-----------------------------------------------------------------------
    #++
    # Return a new instance of KBTable.  Should never be called directly by
    # your application.  Should only be called from KirbyBase#get_table.
    #
    def KBTable.create_called_from_database_instance(db, name, filename)
        return new(db, name, filename)
    end

    #-----------------------------------------------------------------------
    # initialize
    #-----------------------------------------------------------------------
    #++
    # This has been declared private so user's cannot create new instances
    # of KBTable from their application.  A user gets a handle to a KBTable
    # instance by calling KirbyBase#get_table for an existing table or
    # KirbyBase.create_table for a new table.
    #
    def initialize(db, name, filename)
        @db = db
        @name = name
        @filename = filename
        @encrypted = false
        @lookup_key = :recno
        @idx_timestamps = {}
        @idx_arrs = {}

        # Alias delete_all to clear method.
        alias delete_all clear

        update_header_vars
        create_indexes
        create_table_class unless @db.server?
    end

    #-----------------------------------------------------------------------
    # encrypted?
    #-----------------------------------------------------------------------
    #++
    # Returns true if table is encrypted.
    #
    def encrypted?
        if @encrypted
            return true
        else
            return false
        end
    end

    #-----------------------------------------------------------------------
    # field_names
    #-----------------------------------------------------------------------
    #++
    # Return array containing table field names.
    #
    def field_names
        return @field_names
    end

    #-----------------------------------------------------------------------
    # field_types
    #-----------------------------------------------------------------------
    #++
    # Return array containing table field types.
    #
    def field_types
        return @field_types
    end

    #-----------------------------------------------------------------------
    # field_extras
    #-----------------------------------------------------------------------
    #++
    # Return array containing table field extras.
    #
    def field_extras
        return @field_extras
    end

    #-----------------------------------------------------------------------
    # field_indexes
    #-----------------------------------------------------------------------
    #++
    # Return array containing table field indexes.
    #
    def field_indexes
        return @field_indexes
    end

    #-----------------------------------------------------------------------
    # field_defaults
    #-----------------------------------------------------------------------
    #++
    # Return array containing table field defaults.
    #
    def field_defaults
        return @field_defaults
    end

    #-----------------------------------------------------------------------
    # field_requireds
    #-----------------------------------------------------------------------
    #++
    # Return array containing table field requireds.
    #
    def field_requireds
        return @field_requireds
    end

    #-----------------------------------------------------------------------
    # insert
    #-----------------------------------------------------------------------
    #++
    # Insert a new record into a table, return unique record number.
    #
    # *data*:: Array, Hash, Struct instance containing field values of
    #          new record.
    # *insert_proc*:: Proc instance containing insert code. This and the
    #                 data parameter are mutually exclusive.
    #
    def insert(*data, &insert_proc)
        raise 'Cannot specify both a hash/array/struct and a ' + \
         'proc for method #insert!' unless data.empty? or insert_proc.nil?

        raise 'Must specify either hash/array/struct or insert ' + \
         'proc for method #insert!' if data.empty? and insert_proc.nil?

        # Update the header variables.
        update_header_vars

        # Convert input, which could be a proc, an array, a hash, or a
        # Struct into a common format (i.e. hash).
        if data.empty?
            input_rec = convert_input_data(insert_proc)
        else
            input_rec = convert_input_data(data)
        end

        # Check the field values to make sure they are proper types.
        validate_input(input_rec)

        input_rec = Struct.new(*field_names).new(*field_names.zip(
         @field_defaults).collect do |fn, fd|
            if input_rec.has_key?(fn)
                input_rec[fn]
            else
                fd
            end
        end)

        check_required_fields(input_rec)

        check_against_input_for_specials(input_rec)

        new_recno = @db.engine.insert_record(self, @field_names.zip(
         @field_types).collect do |fn, ft|
            convert_to_encoded_string(ft, input_rec[fn])
        end)

        # If there are any associated memo/blob fields, save their values.
        input_rec.each { |r| r.write_to_file if r.is_a?(KBMemo) } if \
         @field_types.include?(:Memo)
        input_rec.each { |r| r.write_to_file if r.is_a?(KBBlob) } if \
         @field_types.include?(:Blob)
                        
        return new_recno
    end

    #-----------------------------------------------------------------------
    # update_all
    #-----------------------------------------------------------------------
    #++
    # Return array of records (Structs) to be updated, in this case all
    # records.
    #
    # *updates*:: Hash or Struct containing updates.
    #
    def update_all(*updates, &update_proc)
        raise 'Cannot specify both a hash/array/struct and a ' + \
         'proc for method #update_all!' unless updates.empty? or \
         update_proc.nil?

        raise 'Must specify either hash/array/struct or update ' + \
         'proc for method #update_all!' if updates.empty? and \
         update_proc.nil?

        # Depending on whether the user supplied an array/hash/struct or a
        # block as update criteria, we are going to call updates in one of
        # two ways.
        if updates.empty?
            update { true }.set &update_proc
        else
            update(*updates) { true }
        end
    end

    #-----------------------------------------------------------------------
    # update
    #-----------------------------------------------------------------------
    #++
    # Return array of records (Structs) to be updated based on select cond.
    #
    # *updates*:: Hash or Struct containing updates.
    # *select_cond*:: Proc containing code to select records to update.
    #
    def update(*updates, &select_cond)
        raise ArgumentError, "Must specify select condition code " + \
         "block.  To update all records, use #update_all instead." if \
         select_cond.nil?

        # Update the header variables.
        update_header_vars

        # Get all records that match the selection criteria and
        # return them in an array.
        result_set = get_matches(:update, @field_names, select_cond)

        # If updates is empty, this means that the user must have specified
        # the updates in KBResultSet#set, i.e.
        # tbl.update {|r| r.recno == 1}.set(:name => 'Bob')
        return result_set if updates.empty?

        # Call KBTable#set and pass it the records to be updated and the
        # updated criteria.
        set(result_set, updates)
    end

    #-----------------------------------------------------------------------
    # []=
    #-----------------------------------------------------------------------
    #++
    # Update record whose recno field equals index.
    #
    # *index*:: Integer specifying recno you wish to select.
    # *updates*:: Hash, Struct, or Array containing updates.
    #
    def []=(index, updates)
        return update(updates) { |r| r.recno == index }
    end

    #-----------------------------------------------------------------------
    # set
    #-----------------------------------------------------------------------
    #++
    # Set fields of records to updated values.  Returns number of records
    # updated.
    #
    # *recs*:: Array of records (Structs) that will be updated.
    # *data*:: Hash, Struct, Proc containing updates.
    #
    def set(recs, data)
        # If updates are not in the form of a Proc, convert updates, which
        # could be an array, a hash, or a Struct into a common format (i.e.
        # hash).
        update_rec = convert_input_data(data) unless data.is_a?(Proc)

        updated_recs = []

        # For each one of the recs that matched the update query, apply the
        # updates to it and write it back to the database table.
        recs.each do |rec|
            temp_rec = rec.dup

            if data.is_a?(Proc)
                begin
                    data.call(temp_rec)
                rescue NoMethodError
                    raise 'Invalid field name in code block: %s' % $!
                end
             else
                @field_names.each { |fn| temp_rec[fn] = update_rec.fetch(fn,
                 temp_rec.send(fn)) }
            end

            # Is the user trying to change something they shouldn't?
            raise 'Cannot update recno field!' unless \
             rec.recno == temp_rec.recno
            raise 'Cannot update internal fpos field!' unless \
             rec.fpos == temp_rec.fpos
            raise 'Cannot update internal line_length field!' unless \
             rec.line_length == temp_rec.line_length

            # Are the data types of the updates correct?
            validate_input(temp_rec)

            check_required_fields(temp_rec)

            check_against_input_for_specials(temp_rec)

            # Apply updates to the record and add it to an array holding
            # updated records.  We need the fpos and line_length because
            # the engine will use them to determine where to write the
            # update and whether the updated record will fit in the old
            # record's spot.
            updated_recs << { :rec => @field_names.zip(@field_types
             ).collect { |fn, ft| convert_to_encoded_string(ft,
             temp_rec.send(fn)) }, :fpos => rec.fpos,
             :line_length => rec.line_length }
 

            # Update any associated blob/memo fields.
            temp_rec.each { |r| r.write_to_file if r.is_a?(KBMemo) } if \
             @field_types.include?(:Memo)
            temp_rec.each { |r| r.write_to_file if r.is_a?(KBBlob) } if \
             @field_types.include?(:Blob)
        end

        # Take all of the update records and write them back out to the
        # table's file.
        @db.engine.update_records(self, updated_recs)

        # Return the number of records updated.
        return recs.size
    end

    #-----------------------------------------------------------------------
    # delete
    #-----------------------------------------------------------------------
    #++
    # Delete records from table and return # deleted.
    #
    # *select_cond*:: Proc containing code to select records.
    #
    def delete(&select_cond)
        raise ArgumentError, 'Must specify select condition code ' + \
         'block.  To delete all records, use #clear instead.' if \
         select_cond.nil?

        # Get all records that match the selection criteria and
        # return them in an array.
        result_set = get_matches(:delete, [:recno], select_cond)

        @db.engine.delete_records(self, result_set)

        # Return the number of records deleted.
        return result_set.size
    end

    #-----------------------------------------------------------------------
    # clear
    #-----------------------------------------------------------------------
    #++
    # Delete all records from table. You can also use #delete_all.
    #
    # *reset_recno_ctr*:: true/false specifying whether recno counter should
    #                     be reset to 0.
    #
    def clear(reset_recno_ctr=true)
        recs_deleted = delete { true }
        pack

        @db.engine.reset_recno_ctr(self) if reset_recno_ctr
        update_header_vars
        return recs_deleted
    end

    #-----------------------------------------------------------------------
    # []
    #-----------------------------------------------------------------------
    #++
    # Return the record(s) whose recno field is included in index.
    #
    # *index*:: Array of Integer(s) specifying recno(s) you wish to select.
    #
    def [](*index)
        return nil if index[0].nil?

        return get_match_by_recno(:select, @field_names, index[0]) if \
         index.size == 1

        recs = select_by_recno_index(*@field_names) { |r|
            index.include?(r.recno)
        }

        return recs
    end

    #-----------------------------------------------------------------------
    # select
    #-----------------------------------------------------------------------
    #++
    # Return array of records (Structs) matching select conditions.
    #
    # *filter*:: List of field names (Symbols) to include in result set.
    # *select_cond*:: Proc containing select code.
    #
    def select(*filter, &select_cond)
        # Declare these variables before the code block so they don't go
        # after the code block is done.
        result_set = []

        # Validate that all names in filter are valid field names.
        validate_filter(filter)

        filter = @field_names if filter.empty?

        # Get all records that match the selection criteria and
        # return them in an array of Struct instances.
        return get_matches(:select, filter, select_cond)
    end

    #-----------------------------------------------------------------------
    # select_by_recno_index
    #-----------------------------------------------------------------------
    #++
    # Return array of records (Structs) matching select conditions.  Select
    # condition block should not contain references to any table column
    # except :recno.  If you need to select by other table columns than just
    # :recno, use #select instead.
    #
    # *filter*:: List of field names (Symbols) to include in result set.
    # *select_cond*:: Proc containing select code.
    #
    def select_by_recno_index(*filter, &select_cond)
        # Declare these variables before the code block so they don't go
        # after the code block is done.
        result_set = []

        # Validate that all names in filter are valid field names.
        validate_filter(filter)

        filter = @field_names if filter.empty?

        # Get all records that match the selection criteria and
        # return them in an array of Struct instances.
        return get_matches_by_recno_index(:select, filter, select_cond)
    end

    #-----------------------------------------------------------------------
    # pack
    #-----------------------------------------------------------------------
    #++
    # Remove blank records from table, return total removed.
    #
    def pack
        raise "Do not execute this method in client/server mode!" if \
         @db.client?

        lines_deleted = @db.engine.pack_table(self)

        update_header_vars

        @db.engine.remove_recno_index(@name)
        @db.engine.remove_indexes(@name)
        create_indexes
        create_table_class unless @db.server?

        return lines_deleted
    end

    #-----------------------------------------------------------------------
    # rename_column
    #-----------------------------------------------------------------------
    #++
    # Rename a column.
    #
    # Make sure you are executing this method while in single-user mode
    # (i.e. not running in client/server mode).
    #
    # *old_col_name*:: Symbol of old column name.
    # *new_col_name*:: Symbol of new column name.
    #
    def rename_column(old_col_name, new_col_name)
        raise "Do not execute this method in client/server mode!" if \
         @db.client?

        raise "Cannot rename recno column!" if old_col_name == :recno
        raise "Cannot give column name of recno!" if new_col_name == :recno

       raise 'Invalid column name to rename: ' % old_col_name unless \
         @field_names.include?(old_col_name)
        
       raise 'New column name already exists: ' % new_col_name if \
         @field_names.include?(new_col_name)

        @db.engine.rename_column(self, old_col_name, new_col_name)

        # Need to reinitialize the table instance and associated indexes.
        @db.engine.remove_recno_index(@name)
        @db.engine.remove_indexes(@name)

        update_header_vars
        create_indexes
        create_table_class unless @db.server?
    end

    #-----------------------------------------------------------------------
    # change_column_type
    #-----------------------------------------------------------------------
    #++
    # Change a column's type.
    #
    # Make sure you are executing this method while in single-user mode
    # (i.e. not running in client/server mode).
    #
    # *col_name*:: Symbol of column name.
    # *col_type*:: Symbol of new column type.
    #
    def change_column_type(col_name, col_type)
        raise "Do not execute this method in client/server mode!" if \
         @db.client?

        raise "Cannot change type for recno column!" if col_name == :recno
        raise 'Invalid column name: ' % col_name unless \
         @field_names.include?(col_name)
        
        raise 'Invalid field type: %s' % col_type unless \
         KBTable.valid_field_type?(col_type)

        @db.engine.change_column_type(self, col_name, col_type)

        # Need to reinitialize the table instance and associated indexes.
        @db.engine.remove_recno_index(@name)
        @db.engine.remove_indexes(@name)

        update_header_vars
        create_indexes
        create_table_class unless @db.server?
    end

    #-----------------------------------------------------------------------
    # add_column
    #-----------------------------------------------------------------------
    #++
    # Add a column to table.
    #
    # Make sure you are executing this method while in single-user mode
    # (i.e. not running in client/server mode).
    #
    # *col_name*:: Symbol of column name to add.
    # *col_type*:: Symbol (or Hash if includes field extras) of column type
    #              to add.
    # *after*:: Symbol of column name that you want to add this column
    #           after.
    #
    def add_column(col_name, col_type, after=nil)
        raise "Do not execute this method in client/server mode!" if \
         @db.client?

        raise "Invalid column name in 'after': #{after}" unless after.nil? \
         or @field_names.include?(after)

        raise "Invalid column name in 'after': #{after}" if after == :recno

        raise "Column name cannot be recno!" if col_name == :recno
        
        raise "Column name already exists!" if @field_names.include?(
         col_name)

        # Does this new column have field extras (i.e. Index, Lookup, etc.)
        if col_type.is_a?(Hash)
            temp_type = col_type[:DataType]
        else
            temp_type = col_type
        end

        raise 'Invalid field type: %s' % temp_type unless \
         KBTable.valid_field_type?(temp_type)

        field_def = @db.build_header_field_string(col_name, col_type)

        @db.engine.add_column(self, field_def, after)

        # Need to reinitialize the table instance and associated indexes.
        @db.engine.remove_recno_index(@name)
        @db.engine.remove_indexes(@name)

        update_header_vars
        create_indexes
        create_table_class unless @db.server?
    end

    #-----------------------------------------------------------------------
    # drop_column
    #-----------------------------------------------------------------------
    #++
    # Drop a column from table.
    #
    # Make sure you are executing this method while in single-user mode
    # (i.e. not running in client/server mode). 
    #
    # *col_name*:: Symbol of column name to add.
    #
    def drop_column(col_name)
        raise "Do not execute this method in client/server mode!" if \
         @db.client?

        raise 'Invalid column name: ' % col_name unless \
         @field_names.include?(col_name)

        raise "Cannot drop :recno column!" if col_name == :recno

        @db.engine.drop_column(self, col_name)

        # Need to reinitialize the table instance and associated indexes.
        @db.engine.remove_recno_index(@name)
        @db.engine.remove_indexes(@name)

        update_header_vars
        create_indexes
        create_table_class unless @db.server?
    end

    #-----------------------------------------------------------------------
    # add_index
    #-----------------------------------------------------------------------
    #++
    # Add an index to a column.
    #
    # Make sure you are executing this method while in single-user mode
    # (i.e. not running in client/server mode).
    #
    # *col_names*:: Array containing column name(s) of new index.
    #
    def add_index(*col_names)
        raise "Do not execute this method in client/server mode!" if \
         @db.client?

        col_names.each do |c|
            raise "Invalid column name: #{c}" unless \
             @field_names.include?(c)
            
            raise "recno column cannot be indexed!" if c == :recno

            raise "Column already indexed: #{c}" unless \
             @field_indexes[@field_names.index(c)].nil?
        end
        
        last_index_no_used = 0
        @field_indexes.each do |i|
            next if i.nil?
            index_no = i[-1..-1].to_i
            last_index_no_used = index_no if index_no > last_index_no_used
        end
        
        @db.engine.add_index(self, col_names, last_index_no_used+1)

        # Need to reinitialize the table instance and associated indexes.
        @db.engine.remove_recno_index(@name)
        @db.engine.remove_indexes(@name)

        update_header_vars
        create_indexes
        create_table_class unless @db.server?
    end

    #-----------------------------------------------------------------------
    # drop_index
    #-----------------------------------------------------------------------
    #++
    # Drop an index on a column(s).
    #
    # Make sure you are executing this method while in single-user mode
    # (i.e. not running in client/server mode).
    #
    # *col_names*:: Array containing column name(s) of new index.
    #
    def drop_index(*col_names)
        raise "Do not execute this method in client/server mode!" if \
         @db.client?

        col_names.each do |c|
            raise "Invalid column name: #{c}" unless \
             @field_names.include?(c)
            
            raise "recno column index cannot be dropped!" if c == :recno

            raise "Column not indexed: #{c}" if \
             @field_indexes[@field_names.index(c)].nil?
        end
        
        @db.engine.drop_index(self, col_names)

        # Need to reinitialize the table instance and associated indexes.
        @db.engine.remove_recno_index(@name)
        @db.engine.remove_indexes(@name)

        update_header_vars
        create_indexes
        create_table_class unless @db.server?
    end

    #-----------------------------------------------------------------------
    # change_column_default_value
    #-----------------------------------------------------------------------
    #++
    # Change a column's default value.
    #
    # Make sure you are executing this method while in single-user mode
    # (i.e. not running in client/server mode).
    #
    # *col_name*:: Symbol of column name.
    # *value*:: New default value for column.
    #
    def change_column_default_value(col_name, value)
        raise "Do not execute this method in client/server mode!" if \
         @db.client?

        raise ":recno cannot have a default value!" if col_name == :recno

        raise 'Invalid column name: ' % col_name unless \
         @field_names.include?(col_name)

        raise 'Cannot set default value for this type: ' + \
         '%s' % @field_types.index(col_name) unless \
         KBTable.valid_default_type?(
          @field_types[@field_names.index(col_name)])
        
        if value.nil?
            @db.engine.change_column_default_value(self, col_name, nil)
        else
            @db.engine.change_column_default_value(self, col_name,
             convert_to_encoded_string(
              @field_types[@field_names.index(col_name)], value))
        end
            
        # Need to reinitialize the table instance and associated indexes.
        @db.engine.remove_recno_index(@name)
        @db.engine.remove_indexes(@name)

        update_header_vars
        create_indexes
        create_table_class unless @db.server?
    end
    
    #-----------------------------------------------------------------------
    # change_column_required
    #-----------------------------------------------------------------------
    #++
    # Change whether a column is required.
    #
    # Make sure you are executing this method while in single-user mode
    # (i.e. not running in client/server mode).
    #
    # *col_name*:: Symbol of column name.
    # *required*:: true or false.
    #
    def change_column_required(col_name, required)
        raise "Do not execute this method in client/server mode!" if \
         @db.client?

        raise ":recno is always required!" if col_name == :recno

        raise 'Invalid column name: ' % col_name unless \
         @field_names.include?(col_name)
        
        raise 'Required must be either true or false!' unless \
         [true, false].include?(required)
        
        @db.engine.change_column_required(self, col_name, required)
            
        # Need to reinitialize the table instance and associated indexes.
        @db.engine.remove_recno_index(@name)
        @db.engine.remove_indexes(@name)

        update_header_vars
        create_indexes
        create_table_class unless @db.server?
    end
    
    #-----------------------------------------------------------------------
    # total_recs
    #-----------------------------------------------------------------------
    #++
    # Return total number of undeleted (blank) records in table.
    #
    def total_recs
        return @db.engine.get_total_recs(self)
    end

    #-----------------------------------------------------------------------
    # import_csv
    #-----------------------------------------------------------------------
    #++
    # Import csv file into table.
    #
    # *csv_filename*:: filename of csv file to import.
    #
    def import_csv(csv_filename)
        records_inserted = 0
        tbl_rec = @table_class.new(self)

        # read with FasterCSV if loaded, or the standard CSV otherwise
        (defined?(FasterCSV) ? FasterCSV : CSV).foreach(csv_filename
         ) do |row|
            tbl_rec.populate([nil] + row)
            insert(tbl_rec)
            records_inserted += 1
        end
        return records_inserted
    end

    #-----------------------------------------------------------------------
    # PRIVATE METHODS
    #-----------------------------------------------------------------------
    private

    #-----------------------------------------------------------------------
    # create_indexes
    #-----------------------------------------------------------------------
    def create_indexes
        # First remove any existing select_by_index methods.  This is in
        # case we are dropping an index or a column.  We want to make sure
        # an select_by_index method doesn't hang around if it's index or
        # column has been dropped.
        #methods.each do |m|
        #    next if m == 'select_by_recno_index'
        #    
        #    if m =~ /select_by_.*_index/
        #        class << self; self end.send(:remove_method, m.to_sym)
        #    end    
        #end

        # Create the recno index.  A recno index always gets created even if
        # there are no user-defined indexes for the table.
        @db.engine.init_recno_index(self) 

        # There can be up to 5 different indexes on a table.  Any of these
        # indexes can be single or compound.
        ['Index->1', 'Index->2', 'Index->3', 'Index->4',
         'Index->5'].each do |idx|
            index_col_names = []
            @field_indexes.each_with_index do |fi,i|
                next if fi.nil?
                index_col_names << @field_names[i] if fi.include?(idx)
            end

            # If no fields were indexed on this number (1..5), go to the
            # next index number.
            next if index_col_names.empty?

            # Create this index on the engine.
            @db.engine.init_index(self, index_col_names) 

            # For each index found, add an instance method for it so that
            # it can be used for #selects.
            select_meth_str = <<-END_OF_STRING
            def select_by_#{index_col_names.join('_')}_index(*filter,
             &select_cond)
                result_set = []
                validate_filter(filter)
                filter = @field_names if filter.empty?
                return get_matches_by_index(:select,
                 [:#{index_col_names.join(',:')}], filter, select_cond)
            end
            END_OF_STRING

            instance_eval(select_meth_str) unless @db.server?
           
            @idx_timestamps[index_col_names.join('_')] = nil
            @idx_arrs[index_col_names.join('_')] = nil
        end
    end

    #-----------------------------------------------------------------------
    # create_table_class
    #-----------------------------------------------------------------------
    def create_table_class
        #This is the class that will be used in #select condition blocks.
        @table_class = Class.new(KBTableRec)

        get_meth_str = ''
        get_meth_upd_res_str = ''
        set_meth_str = ''

        @field_names.zip(@field_types, @field_extras) do |x|
            field_name, field_type, field_extra = x

            @lookup_key = field_name if field_extra.has_key?('Key')

            # These are the default get/set methods for the table column.
            get_meth_str = <<-END_OF_STRING
            def #{field_name}
                return @#{field_name}
            end
            END_OF_STRING
            get_meth_upd_res_str = <<-END_OF_STRING
            def #{field_name}_upd_res
                return @#{field_name}
            end
            END_OF_STRING
            set_meth_str = <<-END_OF_STRING
            def #{field_name}=(s)
                @#{field_name} = convert_to_native_type(:#{field_type}, s)
            end
            END_OF_STRING

            # If this is a Lookup field, modify the get_method.
            if field_extra.has_key?('Lookup')
                lookup_table, key_field = field_extra['Lookup'].split('.')

                # If joining to recno field of lookup table use the
                # KBTable[] method to get the record from the lookup table.
                if key_field == 'recno'
                    get_meth_str = <<-END_OF_STRING
                    def #{field_name}
                        table = @tbl.db.get_table(:#{lookup_table})
                        return table[@#{field_name}]
                    end
                    END_OF_STRING
                else
                    begin
                        unless @db.get_table(lookup_table.to_sym
                         ).respond_to?('select_by_%s_index' % key_field)
                            raise RuntimeError
                        end
                        
                        get_meth_str = <<-END_OF_STRING
                        def #{field_name}
                            table = @tbl.db.get_table(:#{lookup_table})
                            return table.select_by_#{key_field}_index { |r|
                             r.#{key_field} == @#{field_name} }[0]
                        end
                        END_OF_STRING
                    rescue RuntimeError
                        get_meth_str = <<-END_OF_STRING
                        def #{field_name}
                            table = @tbl.db.get_table(:#{lookup_table})
                            return table.select { |r|
                             r.#{key_field} == @#{field_name} }[0]
                        end
                        END_OF_STRING
                    end
                end
            end

            # If this is a Link_many field, modify the get/set methods.
            if field_extra.has_key?('Link_many')
                lookup_field, rest = field_extra['Link_many'].split('=')
                link_table, link_field = rest.split('.')

                begin
                    unless @db.get_table(link_table.to_sym).respond_to?(
                     'select_by_%s_index' % link_field)
                        raise RuntimeError
                    end
                    
                    get_meth_str = <<-END_OF_STRING
                    def #{field_name}
                        table = @tbl.db.get_table(:#{link_table})
                        return table.select_by_#{link_field}_index { |r|
                         r.send(:#{link_field}) == @#{lookup_field} }
                    end
                    END_OF_STRING
                rescue RuntimeError
                    get_meth_str = <<-END_OF_STRING
                    def #{field_name}
                        table = @tbl.db.get_table(:#{link_table})
                        return table.select { |r|
                         r.send(:#{link_field}) == @#{lookup_field} }
                    end
                    END_OF_STRING
                end

                get_meth_upd_res_str = <<-END_OF_STRING
                def #{field_name}_upd_res
                    return kb_nil
                end
                END_OF_STRING
                set_meth_str = <<-END_OF_STRING
                def #{field_name}=(s)
                    @#{field_name} = kb_nil
                end
                END_OF_STRING
            end

            # If this is a Calculated field, modify the get/set methods.
            if field_extra.has_key?('Calculated')
                calculation = field_extra['Calculated']

                get_meth_str = <<-END_OF_STRING
                def #{field_name}()
                    return #{calculation}
                end
                END_OF_STRING
                get_meth_upd_res_str = <<-END_OF_STRING
                def #{field_name}_upd_res()
                    return kb_nil
                end
                END_OF_STRING
                set_meth_str = <<-END_OF_STRING
                def #{field_name}=(s)
                    @#{field_name} = kb_nil
                end
                END_OF_STRING
            end

            @table_class.class_eval(get_meth_str)
            @table_class.class_eval(get_meth_upd_res_str)
            @table_class.class_eval(set_meth_str)
        end
    end

    #-----------------------------------------------------------------------
    # validate_filter
    #-----------------------------------------------------------------------
    #++
    # Check that filter contains valid field names.
    #
    def validate_filter(filter)
        # Each field in the filter array must be a valid fieldname in the
        # table.
        filter.each { |f|
            raise 'Invalid field name: %s in filter!' % f unless \
             @field_names.include?(f)
        }
    end

    #-----------------------------------------------------------------------
    # convert_input_data
    #-----------------------------------------------------------------------
    #++
    # Convert data passed to #input, #update, or #set to a common format.
    #
    def convert_input_data(values)
        temp_hash = {}

        # This only applies to Procs in #insert, Procs in #update are
        # handled in #set.
        if values.is_a?(Proc)
            tbl_rec = Struct.new(*@field_names[1..-1]).new
            begin
                values.call(tbl_rec)
            rescue NoMethodError
                raise 'Invalid field name in code block: %s' % $!
            end

            @field_names[1..-1].each do |f|
                temp_hash[f] = tbl_rec[f] unless tbl_rec[f].nil?
            end

        # Is input data an instance of custom record class, Struct, or
        # KBTableRec?
        elsif values.first.is_a?(Object.full_const_get(@record_class)) or \
         values.first.is_a?(Struct) or values.first.class == @table_class
            @field_names[1..-1].each do |f|
                temp_hash[f] = values.first.send(f) if \
                 values.first.respond_to?(f)
            end

        # Is input data a hash?
        elsif values.first.is_a?(Hash)
            temp_hash = values.first.dup

        # Is input data an array?
        elsif values.is_a?(Array)
            raise ArgumentError, 'Must specify all fields in input array!' \
             unless values.size == @field_names[1..-1].size

            @field_names[1..-1].each do |f|
                temp_hash[f] = values[@field_names.index(f)-1]
            end
        else
            raise(ArgumentError, 'Invalid type for values container!')
        end

        return temp_hash
    end

    #-----------------------------------------------------------------------
    # check_required_fields
    #-----------------------------------------------------------------------
    #++
    # Check that all required fields have values.
    #
    def check_required_fields(data)
        @field_names[1..-1].each do |f|
            raise(ArgumentError,
             'A value for this field is required: %s' % f) if \
             @field_requireds[@field_names.index(f)] and data[f].nil? 
        end
    end

    #-----------------------------------------------------------------------
    # check_against_input_for_specials
    #-----------------------------------------------------------------------
    #++
    # Check that no special field types (i.e. calculated or link_many
    # fields)
    # have been given values.
    #
    def check_against_input_for_specials(data)
        @field_names[1..-1].each do |f|
            raise(ArgumentError,
             'You cannot input a value for this field: %s' % f) if \
             @field_extras[@field_names.index(f)].has_key?('Calculated') \
             or @field_extras[@field_names.index(f)].has_key?('Link_many') \
              and not data[f].nil? 
        end
    end

    #-----------------------------------------------------------------------
    # validate_input
    #-----------------------------------------------------------------------
    #++
    # Check input data to ensure proper data types.
    #
    def validate_input(data)
        @field_names[1..-1].each do |f|
            next if data[f].nil?

            raise 'Invalid data %s for column %s' % [data[f], f] unless \
             KBTable.valid_data_type?(@field_types[@field_names.index(f)],
             data[f])
        end
    end

    #-----------------------------------------------------------------------
    # update_header_vars
    #-----------------------------------------------------------------------
    #++
    # Read header record and update instance variables.
    #
    def update_header_vars
        @encrypted, @last_rec_no, @del_ctr, @record_class, @col_names, \
         @col_types, @col_indexes, @col_defaults, @col_requireds, \
         @col_extras = @db.engine.get_header_vars(self)

        # These are deprecated.
        @field_names = @col_names
        @field_types = @col_types
        @field_indexes = @col_indexes
        @field_defaults = @col_defaults
        @field_requireds = @col_requireds
        @field_extras = @col_extras
    end

    #-----------------------------------------------------------------------
    # get_result_struct
    #-----------------------------------------------------------------------
    #++
    # Return Struct object that will hold result record.
    #
    def get_result_struct(query_type, filter)
        case query_type
        when :select
            return Struct.new(*filter) if @record_class == 'Struct'
        when :update
            return Struct.new(*(filter + [:fpos, :line_length]))
        when :delete
            return Struct.new(:recno, :fpos, :line_length)
        end
        return nil
    end

    #-----------------------------------------------------------------------
    # create_result_rec
    #-----------------------------------------------------------------------
    #++
    # Return Struct/custom class populated with table row data.
    #
    def create_result_rec(query_type, filter, result_struct, tbl_rec, rec)
        # If this isn't a select query or if it is a select query, but
        # the table record class is simply a Struct, then we will use
        # a Struct for the result record type.
        if query_type != :select
            result_rec = result_struct.new(*filter.collect { |f|
             tbl_rec.send("#{f}_upd_res".to_sym) })
        elsif @record_class == 'Struct'
            result_rec = result_struct.new(*filter.collect do |f|
                if tbl_rec.send(f).kb_nil?
                    nil
                else
                    tbl_rec.send(f)
                end
            end)
        else
            if Object.full_const_get(@record_class).respond_to?(:kb_create)
                result_rec = Object.full_const_get(@record_class
                 ).kb_create(*@field_names.collect do |f|
                    # Just a warning here:  If you specify a filter on
                    # a select, you are only going to get those fields
                    # you specified in the result set, EVEN IF
                    # record_class is a custom class instead of Struct.
                    if filter.include?(f)
                        if tbl_rec.send(f).kb_nil?
                            nil
                        else
                            tbl_rec.send(f)
                        end
                    else
                        nil
                    end
                end)
            elsif Object.full_const_get(@record_class).respond_to?(
             :kb_defaults)
                result_rec = Object.full_const_get(@record_class).new(
                 *@field_names.collect do |f|
                    if tbl_rec.send(f).kb_nil?
                        nil
                    else
                        tbl_rec.send(f) || Object.full_const_get(
                         @record_class).kb_defaults[@field_names.index(f)]
                    end
                end)
            else
                result_rec = Object.full_const_get(@record_class).allocate
                @field_names.each do |fn|
                    if tbl_rec.send(fn).kb_nil?
                        result_rec.send("#{fn}=", nil)
                    else
                        result_rec.send("#{fn}=", tbl_rec.send(fn))
                    end
                end
            end
        end

        unless query_type == :select
            result_rec.fpos = rec[-2]
            result_rec.line_length = rec[-1]
        end
        return result_rec
    end

    #-----------------------------------------------------------------------
    # get_matches
    #-----------------------------------------------------------------------
    #++
    # Return records from table that match select condition.
    #
    def get_matches(query_type, filter, select_cond)
        result_struct = get_result_struct(query_type, filter)
        match_array = KBResultSet.new(self, filter, filter.collect { |f|
         @field_types[@field_names.index(f)] })

        tbl_rec = @table_class.new(self)

        # Loop through table.
        @db.engine.get_recs(self).each do |rec|
            tbl_rec.populate(rec)

            next if select_cond and not select_cond.call(tbl_rec)

            match_array << create_result_rec(query_type, filter,
             result_struct, tbl_rec, rec)
        end
        return match_array
    end

    #-----------------------------------------------------------------------
    # get_matches_by_index
    #-----------------------------------------------------------------------
    #++
    # Return records from table that match select condition using one of
    # the table's indexes instead of searching the whole file.
    #
    def get_matches_by_index(query_type, index_fields, filter, select_cond)
        good_matches = []

        idx_struct = Struct.new(*(index_fields + [:recno]))

        begin
            if @db.client?
                # If client, check to see if the copy of the index we have
                # is up-to-date.  If it is not up-to-date, grab a new copy
                # of the index array from the engine.
                unless @idx_timestamps[index_fields.join('_')] == \
                 @db.engine.get_index_timestamp(self, index_fields.join(
                 '_'))
                    @idx_timestamps[index_fields.join('_')] = \
                     @db.engine.get_index_timestamp(self, index_fields.join(
                     '_'))
                     
                    @idx_arrs[index_fields.join('_')] = \
                     @db.engine.get_index(self, index_fields.join('_'))
                end
            else
                # If running single-user, grab the index array from the 
                # engine.
                @idx_arrs[index_fields.join('_')] = \
                 @db.engine.get_index(self, index_fields.join('_'))
            end

            @idx_arrs[index_fields.join('_')].each do |rec|
                good_matches << rec[-1] if select_cond.call(
                 idx_struct.new(*rec))
            end
        rescue NoMethodError
            raise 'Field name in select block not part of index!'
        end

        return get_matches_by_recno(query_type, filter, good_matches)
    end

    #-----------------------------------------------------------------------
    # get_matches_by_recno_index
    #-----------------------------------------------------------------------
    #++
    # Return records from table that match select condition using the
    # table's recno index instead of searching the whole file.
    #
    def get_matches_by_recno_index(query_type, filter, select_cond)
        good_matches = []
        idx_struct = Struct.new(:recno)

        begin
            @db.engine.get_recno_index(self).each_key do |key|
                good_matches << key if select_cond.call(idx_struct.new(key))
            end
        rescue NoMethodError
            raise "You can only use recno field in select block!"
        end

        return nil if good_matches.empty?
        return get_matches_by_recno(query_type, filter, good_matches)
    end

    #-----------------------------------------------------------------------
    # get_match_by_recno
    #-----------------------------------------------------------------------
    #++
    # Return record from table that matches supplied recno.
    #
    def get_match_by_recno(query_type, filter, recno)
        result_struct = get_result_struct(query_type, filter)
        match_array = KBResultSet.new(self, filter, filter.collect { |f|
         @field_types[@field_names.index(f)] })

        tbl_rec = @table_class.new(self)

        rec = @db.engine.get_rec_by_recno(self, recno)
        return nil if rec.nil?
        tbl_rec.populate(rec)

        return create_result_rec(query_type, filter, result_struct,
         tbl_rec, rec)
    end

    #-----------------------------------------------------------------------
    # get_matches_by_recno
    #-----------------------------------------------------------------------
    #++
    # Return records from table that match select condition.
    #
    def get_matches_by_recno(query_type, filter, recnos)
        result_struct = get_result_struct(query_type, filter)
        match_array = KBResultSet.new(self, filter, filter.collect { |f|
         @field_types[@field_names.index(f)] })

        tbl_rec = @table_class.new(self)

        @db.engine.get_recs_by_recno(self, recnos).each do |rec|
            next if rec.nil?
            tbl_rec.populate(rec)

            match_array << create_result_rec(query_type, filter,
             result_struct, tbl_rec, rec)
        end
        return match_array
    end
end


#---------------------------------------------------------------------------
# KBMemo
#---------------------------------------------------------------------------
class KBMemo
    attr_accessor :filepath, :contents

    #-----------------------------------------------------------------------
    # initialize
    #-----------------------------------------------------------------------
    def initialize(db, filepath, contents='')
        @db = db
        @filepath = filepath
        @contents = contents
    end
    
    #-----------------------------------------------------------------------
    # read_from_file
    #-----------------------------------------------------------------------
    def read_from_file
        @contents = @db.engine.read_memo_file(@filepath)
    end
    
    #-----------------------------------------------------------------------
    # write_to_file
    #-----------------------------------------------------------------------
    def write_to_file
        @db.engine.write_memo_file(@filepath, @contents)
    end
end


#---------------------------------------------------------------------------
# KBBlob
#---------------------------------------------------------------------------
class KBBlob
    attr_accessor :filepath, :contents

    #-----------------------------------------------------------------------
    # initialize
    #-----------------------------------------------------------------------
    def initialize(db, filepath, contents='')
        @db = db
        @filepath = filepath
        @contents = contents
    end
    
    #-----------------------------------------------------------------------
    # read_from_file
    #-----------------------------------------------------------------------
    def read_from_file
        @contents = @db.engine.read_blob_file(@filepath)
    end

    #-----------------------------------------------------------------------
    # write_to_file
    #-----------------------------------------------------------------------
    def write_to_file
        @db.engine.write_blob_file(@filepath, @contents)
    end
end


#---------------------------------------------------------------------------
# KBIndex
#---------------------------------------------------------------------------
class KBIndex
    include KBTypeConversionsMixin
    include KBEncryptionMixin

    #-----------------------------------------------------------------------
    # initialize
    #-----------------------------------------------------------------------
    def initialize(table, index_fields)
        @last_update = Time.new
        @idx_arr = []
        @table = table
        @index_fields = index_fields
        @col_poss = index_fields.collect {|i| table.field_names.index(i) }
        @col_names = index_fields
        @col_types = index_fields.collect {|i|
         table.field_types[table.field_names.index(i)]}
    end

    #-----------------------------------------------------------------------
    # get_idx
    #-----------------------------------------------------------------------
    def get_idx
        return @idx_arr
    end

    #-----------------------------------------------------------------------
    # get_timestamp
    #-----------------------------------------------------------------------
    def get_timestamp
        return @last_update
    end

    #-----------------------------------------------------------------------
    # rebuild
    #-----------------------------------------------------------------------
    def rebuild(fptr)
        @idx_arr.clear

        encrypted = @table.encrypted?

        # Skip header rec.
        fptr.readline

        begin
            # Loop through table.
            while true
                line = fptr.readline

                line = unencrypt_str(line) if encrypted
                line.strip!

                # If blank line (i.e. 'deleted'), skip it.
                next if line == ''

                # Split the line up into fields.
                rec = line.split('|', @col_poss.max+2)

                append_new_rec_to_index_array(rec)
            end
        # Here's how we break out of the loop...
        rescue EOFError
        end
    
        @last_update = Time.new
    end
    
    #-----------------------------------------------------------------------
    # add_index_rec
    #-----------------------------------------------------------------------
    def add_index_rec(rec)
        @last_upddate = Time.new if append_new_rec_to_index_array(rec)
    end

    #-----------------------------------------------------------------------
    # delete_index_rec
    #-----------------------------------------------------------------------
    def delete_index_rec(recno)
        i = @idx_arr.rassoc(recno.to_i)
        @idx_arr.delete_at(@idx_arr.index(i)) unless i.nil?
        @last_update = Time.new
    end

    #-----------------------------------------------------------------------
    # update_index_rec
    #-----------------------------------------------------------------------
    def update_index_rec(rec)
        delete_index_rec(rec.first.to_i)
        add_index_rec(rec)
    end

    #-----------------------------------------------------------------------
    # append_new_rec_to_index_array
    #-----------------------------------------------------------------------
    def append_new_rec_to_index_array(rec)
        idx_rec = []
        @col_poss.zip(@col_types).each do |col_pos, col_type|
            idx_rec << convert_to_native_type(col_type, rec[col_pos])
         end

        return false if idx_rec.uniq == [kb_nil]

        idx_rec << rec.first.to_i
        @idx_arr << idx_rec
        return true
    end
end


#---------------------------------------------------------------------------
# KBRecnoIndex
#---------------------------------------------------------------------------
class KBRecnoIndex
    include KBEncryptionMixin

    #-----------------------------------------------------------------------
    # initialize
    #-----------------------------------------------------------------------
    def initialize(table)
        @idx_hash = {}
        @table = table
    end

    #-----------------------------------------------------------------------
    # get_idx
    #-----------------------------------------------------------------------
    def get_idx
        return @idx_hash
    end

    #-----------------------------------------------------------------------
    # rebuild
    #-----------------------------------------------------------------------
    def rebuild(fptr)
        @idx_hash.clear

        encrypted = @table.encrypted?

        begin
            # Skip header rec.
            fptr.readline

            # Loop through table.
            while true
                # Record current position in table.  Then read first
                # detail record.
                fpos = fptr.tell
                line = fptr.readline

                line = unencrypt_str(line) if encrypted
                line.strip!

                # If blank line (i.e. 'deleted'), skip it.
                next if line == ''

                # Split the line up into fields.
                rec = line.split('|', 2)

                @idx_hash[rec.first.to_i] = fpos
            end
        # Here's how we break out of the loop...
        rescue EOFError
        end
    end

    #-----------------------------------------------------------------------
    # add_index_rec
    #-----------------------------------------------------------------------
    def add_index_rec(recno, fpos)
        raise 'Table already has index record for recno: %s' % recno if \
         @idx_hash.has_key?(recno.to_i)
        @idx_hash[recno.to_i] = fpos
    end

    #-----------------------------------------------------------------------
    # update_index_rec
    #-----------------------------------------------------------------------
    def update_index_rec(recno, fpos)
        raise 'Table has no index record for recno: %s' % recno unless \
         @idx_hash.has_key?(recno.to_i)
        @idx_hash[recno.to_i] = fpos
    end

    #-----------------------------------------------------------------------
    # delete_index_rec
    #-----------------------------------------------------------------------
    def delete_index_rec(recno)
        raise 'Table has no index record for recno: %s' % recno unless \
         @idx_hash.has_key?(recno.to_i)
        @idx_hash.delete(recno.to_i)
    end
end


#---------------------------------------------------------------------------
# KBTableRec
#---------------------------------------------------------------------------
class KBTableRec
    include KBTypeConversionsMixin

    def initialize(tbl)
        @tbl = tbl
    end

    def populate(rec)
        @tbl.field_names.zip(rec).each do |fn, val|
            send("#{fn}=", val)
        end
    end

    def clear
        @tbl.field_names.each do |fn|
            send("#{fn}=", kb_nil)
        end
    end
end


#---------------------------------------------------------
# KBResultSet
#---------------------------------------------------------------------------
class KBResultSet < Array
    #-----------------------------------------------------------------------
    # KBResultSet.reverse
    #-----------------------------------------------------------------------
    def KBResultSet.reverse(sort_field)
        return [sort_field, :desc]
    end

    #-----------------------------------------------------------------------
    # initialize
    #-----------------------------------------------------------------------
    def initialize(table, filter, filter_types, *args)
        @table = table
        @filter = filter
        @filter_types = filter_types
        super(*args)

        @filter.each do |f|
            get_meth_str = <<-END_OF_STRING
            def #{f}()
                if defined?(@#{f}) then
                    return @#{f}
                else
                    @#{f} = self.collect { |x| x.#{f} }
                    return @#{f}
                end
            end
            END_OF_STRING
            self.class.class_eval(get_meth_str)
        end
    end

    #-----------------------------------------------------------------------
    # to_ary
    #-----------------------------------------------------------------------
    def to_ary
        to_a
    end

    #-----------------------------------------------------------------------
    # set
    #-----------------------------------------------------------------------
    #++
    # Update record(s) in table, return number of records updated.
    #
    def set(*updates, &update_cond)
        raise 'Cannot specify both a hash and a proc for method #set!' \
         unless updates.empty? or update_cond.nil?

        raise 'Must specify update proc or hash for method #set!' if \
         updates.empty? and update_cond.nil?

        if updates.empty?
            @table.set(self, update_cond)
        else
            @table.set(self, updates)
        end
    end

    #-----------------------------------------------------------------------
    # sort
    #-----------------------------------------------------------------------
    def sort(*sort_fields)
        sort_fields_arrs = []
        sort_fields.each do |f|
            if f.to_s[0..0] == '-'
                sort_fields_arrs << [f.to_s[1..-1].to_sym, :desc]
            elsif f.to_s[0..0] == '+'
                sort_fields_arrs << [f.to_s[1..-1].to_sym, :asc]
            else
                sort_fields_arrs << [f, :asc]
            end
        end

        sort_fields_arrs.each do |f|
            raise "Invalid sort field" unless @filter.include?(f[0])
        end

        super() { |a,b|
            x = []
            y = []
            sort_fields_arrs.each do |s|
                if [:Integer, :Float].include?(
                 @filter_types[@filter.index(s[0])])
                    a_value = a.send(s[0]) || 0
                    b_value = b.send(s[0]) || 0
                else
                    a_value = a.send(s[0])
                    b_value = b.send(s[0])
                end
                if s[1] == :desc
                    x << b_value
                    y << a_value
                else
                    x << a_value
                    y << b_value
                end
            end

            x <=> y
        }
    end

    #-----------------------------------------------------------------------
    # to_report
    #-----------------------------------------------------------------------
    def to_report(recs_per_page=0, print_rec_sep=false)
        result = collect { |r| @filter.collect {|f| r.send(f)} }

        # How many records before a formfeed.
        delim = ' | '

        # columns of physical rows
        columns = [@filter].concat(result).transpose

        max_widths = columns.collect { |c|
            c.max { |a,b| a.to_s.length <=> b.to_s.length }.to_s.length
        }

        row_dashes = '-' * (max_widths.inject {|sum, n| sum + n} +
         delim.length * (max_widths.size - 1))

        justify_hash = { :String => :ljust, :Integer => :rjust,
         :Float => :rjust, :Boolean => :ljust, :Date => :ljust,
         :Time => :ljust, :DateTime => :ljust }

        header_line = @filter.zip(max_widths, @filter.collect { |f|
            @filter_types[@filter.index(f)] }).collect { |x,y,z|
                 x.to_s.send(justify_hash[z], y) }.join(delim)

        output = ''
        recs_on_page_cnt = 0

        result.each do |row|
            if recs_on_page_cnt == 0
                output << header_line + "\n" << row_dashes + "\n"
            end

            output << row.zip(max_widths, @filter.collect { |f|
                @filter_types[@filter.index(f)] }).collect { |x,y,z|
                    x.to_s.send(justify_hash[z], y) }.join(delim) + "\n"

            output << row_dashes + '\n' if print_rec_sep
            recs_on_page_cnt += 1

            if recs_per_page > 0 and (recs_on_page_cnt ==
             num_recs_per_page)
                output << '\f'
                recs_on_page_count = 0
            end
        end
        return output
    end
end


#---------------------------------------------------------------------------
# KBNilClass
#---------------------------------------------------------------------------
class KBNilClass 
    include Comparable

    class << self
        def new
            @kb_nil ||= KBNilClass.allocate
        end
    end

    def inspect
        'kb_nil'
    end

    def kb_nil?
        true
    end

    def to_s
        ""
    end

    def to_i
        0
    end

    def to_f
        0.0
    end

    def to_a
        []
    end

    def <=>(other)
        return 0 if other.kb_nil?
        return -1
    end

    def coerce(other)
        return [other, to_i] if other.kind_of? Fixnum
        return [other, to_f] if other.kind_of? Float

        raise "Didn't know how to coerce kb_nil to a #{other.class}"
    end

    def method_missing(sym, *args)
        kb_nil
    end
end


#---------------------------------------------------------------------------
# Kernel
#---------------------------------------------------------------------------
module Kernel
    def kb_nil
        KBNilClass.new
    end
end


#---------------------------------------------------------------------------
# Object
#---------------------------------------------------------------------------
class Object
    def full_const_get(name)
        list = name.split("::")
        obj = Object
        list.each {|x| obj = obj.const_get(x) }
        obj
    end

    def kb_nil?
        false
    end
end


#---------------------------------------------------------------------------
# Symbol
#---------------------------------------------------------------------------
class Symbol
    #-----------------------------------------------------------------------
    # -@
    #-----------------------------------------------------------------------
    #
    # This allows you to put a minus sign in front of a field name in order
    # to specify descending sort order.
    def -@
        ("-"+self.to_s).to_sym
    end

    #-----------------------------------------------------------------------
    # +@
    #-----------------------------------------------------------------------
    #
    # This allows you to put a plus sign in front of a field name in order
    # to specify ascending sort order.
    def +@
        ("+"+self.to_s).to_sym
    end
end


