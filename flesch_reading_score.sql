CREATE OR REPLACE FUNCTION syllable_count(word TEXT)
RETURNS INTEGER AS $$
DECLARE
    syllable_count INTEGER := 0;
    vowels TEXT := 'aeiouy';
    i INTEGER;
    len INTEGER := length(word);
    c CHAR;
    prev_c CHAR;
BEGIN
    IF len = 0 THEN
        RETURN 0;
    END IF;

    if word ~ '^[0-9]+$' then
        RETURN 1; -- since numbers are easily understood, they are counted as 1 syllable.
    end if;

    if word ~ '[\/"%*0-9“''{}]' or word ~ '[,.](?=.)' then
        RETURN 3; -- non-word formations such as URLs, paths, etc. are counted as constantly 3 syllables since their actual syllable count is not relevant in the context of the Flesch Reading Score.
    end if;

    word := lower(word);

    -- First letter
    IF substring(word FROM 1 FOR 1) ~ ('[' || vowels || ']') THEN
        syllable_count := syllable_count + 1;
    END IF;

    -- Rest of the letters
    FOR i IN 2..len LOOP
        c := substring(word FROM i FOR 1);
        prev_c := substring(word FROM i-1 FOR 1);
        IF c ~ ('[' || vowels || ']') AND prev_c !~ ('[' || vowels || ']') THEN
            syllable_count := syllable_count + 1;
        END IF;
    END LOOP;

    -- Ending with 'e'
    IF word LIKE '%e' THEN
        syllable_count := syllable_count - 1;
    END IF;

    -- Ending with 'le' after consonant
    IF word LIKE '%le' AND len > 2 THEN
        IF substring(word FROM len-2 FOR 1) !~ ('[' || vowels || ']') THEN
            syllable_count := syllable_count + 1;
        END IF;
    END IF;

    -- Minimum of 1 syllable
    IF syllable_count < 1 THEN
        syllable_count := 1;
    END IF;

    RETURN syllable_count;
END;
$$ LANGUAGE plpgsql IMMUTABLE STRICT;

create or replace function flesch_reading_score(text) returns float as $$
declare
    text_length integer;
    sentence_count integer;
    word_count integer;
    syllable_count integer;
    score float;
begin
    -- Calculate the number of sentences, words, and syllables
    select count(*) into sentence_count from regexp_split_to_table($1, '[.!?]') as s;
    select count(*) into word_count from regexp_split_to_table($1, '\s+') as w;
    select sum(syllable_count(w)) into syllable_count from regexp_split_to_table($1, '\s+') as w;

    -- Calculate the Flesch Reading Ease score
    if word_count = 0 or sentence_count = 0 then
        return 0; -- Avoid division by zero
    end if;

    score := 206.835 - (1.015 * (word_count / sentence_count)) - (84.6 * (syllable_count / word_count));
    return score;
end;
$$ LANGUAGE plpgsql IMMUTABLE STRICT;