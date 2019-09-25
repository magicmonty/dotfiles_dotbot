#key: doriangray
#point_line:33
#point_index:2
# --
doriangray =
["The books that the world calls immoral are books that show the world its own shame.",
  "You will always be fond of me.\nI represent to you all the sins you never had the courage to commit.",
  "Experience is merely the name men gave to their mistakes.",
  "Those who find ugly meanings in beautiful things are corrupt without being charming.\nThis is a fault.\nThose who find beautiful meanings in beautiful things are the cultivated.\nFor these there is hope.\nThey are the elect to whom beautiful things mean only Beauty.\nThere is no such thing as a moral or an immoral book.\nBooks are well written, or badly written.\nThat is all.",
  "I don't want to be at the mercy of my emotions.\nI want to use them, to enjoy them, and to dominate them.",
  "The only way to get rid of temptation is to yield to it.",
  "To define is to limit.",
  "There is only one thing in the world worse than being talked about, and that is not being talked about.",
  "Nowadays people know the price of everything and the value of nothing.",
  "I am too fond of reading books to care to write them.",
  "When one is in love, one always begins by deceiving one's self, and one always ends by deceiving others.\nThat is what the world calls a romance.",
  "Children begin by loving their parents; as they grow older they judge them;\nsometimes they forgive them.",
  "Behind every exquisite thing that existed, there was something tragic.",
  "Humanity takes itself too seriously. It is the world's original sin.\nIf the cave-man had known how to laugh, History would have been different.",
  "Nowadays most people die of a sort of creeping common sense, and discover when it is too late that the only things one never regrets are one's mistakes.",
  "Nothing can cure the soul but the senses, just as nothing can cure the senses but the soul.",
  "Words! Mere words! How terrible they were!\nHow clear, and vivid, and cruel!\nOne could not escape from them.\nAnd yet what a subtle magic there was in them!\nThey seemed to be able to give a plastic form to formless things, and to have a music of their own as sweet as that of viol or of lute.\nMere words!\nWas there anything so real as words?",
  "Live! Live the wonderful life that is in you!\nLet nothing be lost upon you.\nBe always searching for new sensations.\nBe afraid of nothing.",
  "Some things are more precious because they don't last long.",
  "Laughter is not at all a bad beginning for a friendship, and it is by far the best ending for one.",
  "Every portrait that is painted with feeling is a portrait of the artist,\nnot of the sitter.",
  "Whenever a man does a thoroughly stupid thing, it is always from the noblest motives.",
  "The world is changed because you are made of ivory and gold.\nThe curves of your lips rewrite history.",
  "There is no such thing as a moral or an immoral book.\nBooks are well written, or badly written.\nThat is all.",
  "You must have a cigarette.\nA cigarette is the perfect type of a perfect pleasure.\nIt is exquisite, and it leaves one unsatisfied.\nWhat more can one want?",
  "The basis of optimism is sheer terror.",
  "I have grown to love secrecy.\nIt seems to be the one thing that can make modern life mysterious or marvelous to us.\nThe commonest thing is delightful if only one hides it.",
  "I love acting.\nIt is so much more real than life.",
  "What does it profit a man if he gain the whole world and lose his own soul?"
  ].ring

live_loop :doriangray, sync: :clock1 do
  q = doriangray.tick(:q)
  notify q
  sleep 0.25
end
