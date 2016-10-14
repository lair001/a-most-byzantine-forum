module Slugifiable

  STOP_WORD_ARRAY = [
    'a',
    'about',
    'above',
    'after',
    'again',
    'against',
    'all',
    'am',
    'an',
    'and',
    'any',
    'are',
    "aren't",
    'as',
    'at',
    'be',
    'because',
    'been',
    'before',
    'being',
    'below',
    'between',
    'both',
    'but',
    'by',
    "can't",
    'cannot',
    'could',
    "couldn't",
    'did',
    "didn't",
    'do',
    'does',
    "doesn't",
    'doing',
    "don't",
    'down',
    'during',
    'each',
    'few',
    'for',
    'from',
    'further',
    'had',
    "hadn't",
    'has',
    "hasn't",
    'have',
    "haven't",
    'having',
    'he',
    "he'd",
    "he'll",
    "he's",
    'her',
    'here',
    "here's",
    'hers',
    'herself',
    'him',
    'himself',
    'his',
    'how',
    "how's",
    'i',
    "i'd",
    "i'll",
    "i'm",
    "i've",
    'if',
    'in',
    'into',
    'is',
    "isn't",
    'it',
    "it's",
    'its',
    'itself',
    "let's",
    'me',
    'more',
    'most',
    "mustn't",
    'my',
    'myself',
    'no',
    'nor',
    'not',
    'of',
    'off',
    'on',
    'once',
    'only',
    'or',
    'other',
    'ought',
    'our',
    'ours',
    'ourselves',
    'out',
    'over',
    'own',
    'same',
    "shan't",
    'she',
    "she'd",
    "she'll",
    "she's",
    'should',
    "shouldn't",
    'so',
    'some',
    'such',
    'than',
    'that',
    "that's",
    'the',
    'their',
    'theirs',
    'them',
    'themselves',
    'then',
    'there',
    "there's",
    'these',
    'they',
    "they'd",
    "they'll",
    "they're",
    "they've",
    'this',
    'those',
    'through',
    'to',
    'too',
    'under',
    'until',
    'up',
    'very',
    'was',
    "wasn't",
    'we',
    "we'd",
    "we'll",
    "we're",
    "we've",
    'were',
    "weren't",
    'what',
    "what's",
    'when',
    "when's",
    'where',
    "where's",
    'which',
    'while',
    'who',
    "who's",
    'whom',
    'why',
    "why's",
    'with',
    "won't",
    'would',
    "wouldn't",
    'you',
    "you'd",
    "you'll",
    "you're",
    "you've",
    'your',
    'yours',
    'yourself',
    'yourselves',
    'zero'
  ]

  STOP_WORD_REGEX = Regexp.new('(-' + STOP_WORD_ARRAY.join('-|-') + '-)' )
  STOP_WORD_REGEX_FOR_STRING_ENDS = Regexp.new('(^' + STOP_WORD_ARRAY.join('-|^') + '-|-' + STOP_WORD_ARRAY.join('$|-') + '$)' )
  UNSAFE_CHARACTER_REGEX = /[\s#%}?{$,|.^+\[\]`;><:@"=&\/\\]+/

  module InstanceMethods

    def slugify(attribute)
      return self.send(attribute).downcase.gsub(UNSAFE_CHARACTER_REGEX, '-').gsub(STOP_WORD_REGEX, '-').gsub(STOP_WORD_REGEX_FOR_STRING_ENDS, '') if self.send(attribute).is_a?(String)
      nil
    end

    def presence_of_unique_slug
      if self.slug.nil?
        errors.add(:base, 'Must have a slug.')
      elsif !self.class.validate_by_slug(self) 
        errors.add(:base, 'Must have a unique slug.')
      end
    end

  end

  module ClassMethods

    def find_by_slug(slug)
      self.all.each do |instance|
        return instance if instance.slug == slug
      end
      nil
    end

    def validate_by_slug(object)
      return false if object.class != self || object.slug.nil? || object.slug.match(/[^-]/).nil?
      self.all.each do |instance|
        return false if instance.slug == object.slug && instance != object
      end
      true
    end

  end

end
