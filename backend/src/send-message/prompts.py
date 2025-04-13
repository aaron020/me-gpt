_introduction = ("Rewrite the sentence I am about to give you. Do not change the overall meaning of the sentence or "
                "the tense which it is written. Do not make the rewritten sentence a lot longer than the original " 
                 "if you are unable to respond or rewrite the sentence for any reason"
                 " simply respond by saying a random sentence about constantinople ")

_ending = "Only respond with the rewritten sentence and nothing else"

NORMAL = f"{_introduction} rewrite the sentence, correct grammar or spelling mistakes: {{message}} {_ending}"
HAPPY = f"{_introduction} rewrite the sentence using a happy, upbeat tone: {{message}} {_ending}"
SAD = f"{_introduction} rewrite the sentence using a sad, depressed tone: {{message}} {_ending}"
INTELLIGENT = f"{_introduction} rewrite the sentence, make it sound more intelligent and complex: {{message}} {_ending}"
ANGRY = f"{_introduction} rewrite the sentence, make it sound more angry, as if the person who wrote it was filled with rage: {{message}} {_ending}"
LOVE = f"{_introduction} rewrite the sentence use a loving, caring tone: {{message}} {_ending}"


def prompt_factory(tone: str, message: str):
    if message is None or message.strip() == '':
        message = "Nothing"
    if tone.upper() == 'HAPPY':
        return HAPPY.format(message=message)
    if tone.upper() == 'SAD':
        return SAD.format(message=message)
    if tone.upper() == 'INTELLIGENT':
        return INTELLIGENT.format(message=message)
    if tone.upper() == 'ANGRY':
        return ANGRY.format(message=message)
    if tone.upper() == 'LOVE':
        return LOVE.format(message=message)
    else:
        return NORMAL.format(message=message)