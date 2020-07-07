class StringAnalyzer 
    def has_vowels?(str)
        !!(str =~ /[aeiou]+/i) #!!(str =~ /[aeio]+/i)
    end
end