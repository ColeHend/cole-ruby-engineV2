class Battle_Equipment
    attr_accessor :weapon, :shield, :helm, :necklace, :chest, :hands, :legs, :feet
    attr_reader :totalArmor
    def initialize(weapon=nil,shield=nil,helm=nil,necklace=nil,chest=nil,hands=nil,legs=nil,feet=nil)
        @weapon = weapon
        @shield = shield
        @helm = helm
        @necklace = necklace
        @chest = chest
        @hands = hands
        @legs = legs
        @feet = feet
        @totalArmor = total_ac(0)
    end
    def getMod(stat)
        modifier = ((stat - 10))
        return modifier
    end
    def total_ac(modifier = 0)
        totalAC = 5 + (2 * getMod(@dex))
        if @shield.is_a?(Armor)
            totalAC += @shield.armor
        end
        if @helm.is_a?(Armor)
            totalAC += @helm.armor
        end
        if @chest.is_a?(Armor)
            totalAC += @chest.armor
        end
        if @hands.is_a?(Armor)
            totalAC += @hands.armor
        end
        if @legs.is_a?(Armor)
            totalAC += @legs.armor
        end
        if @feet.is_a?(Armor)
            totalAC += @feet.armor
        end
        return totalAC + modifier
    end
end