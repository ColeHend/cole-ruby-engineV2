require_relative "battle/battle_equipment.rb"
class Battle_Core
    attr_accessor :currentHP, :alive, :exp, :playerLevel,:enemyGroups, :hateGroup
    attr_accessor :knownSpells, :currentSpell, :allSpells
    attr_accessor :str, :dex, :int, :con, :hp, :mRes, :equipment
    def initialize(name,hp=15.0,str=14,dex=12,int=12,con=12,mRes=1,equipment=Battle_Equipment.new())
        @alive = true
        @name = name
        @hp = hp
        @currentHP = hp
        @playerLevel = 1
        @exp = 0
        @str, @dex, @int, @con, @mRes = str, dex, int, con, mRes
        @equipment = equipment
        @lvlUpExp = (1000*@playerLevel)
        @hateGroup = "player"
        @enemyGroups = ["sandslash","hitmonchan","charizard"]
        #spells
        @allSpells = [[1,"firebolt"]]
        @knownSpells = []
        @currentSpell = nil
        #equipment
    end
    def set_groups(hateGroup,enemyGroupArr)
        if hateGroup != nil
            @hateGroup = hateGroup
        end
        if enemyGroupArr != nil
            @enemyGroups = enemyGroupArr
        end
    end
    def set_stats(hp,str,dex,int,con,mRes)
        if hp != nil
            @hp = hp
         elsif str != nil
            @str = str
         elsif dex != nil
            @dex = dex
         elsif int != nil
            @int = int
         elsif con != nil
            @con = con
         elsif mRes != nil
            @mRes = mRes
        end
    end

    def level_up
        #stat increases and stuff
        @playerLevel = (@playerLevel+1)
        @lvlUpExp = (1000*@playerLevel) 
        if @playerLevel % 2 == 0
            @con += 1
            @str += 1
        end
        if @playerLevel % 2 == 1
            @dex += 1
            @int += 1
        end
        @allSpells.each{|spell|
            if @playerLevel == spell[0]
                @knownSpells.push(spell[1])
            end
        }
        self.hp = (self.hp+(4*getMod(@con)))
    end

    def give_xp(expAmt)
        @exp += expAmt
        while @exp >= @lvlUpExp
            level_up()
        end
    end
end