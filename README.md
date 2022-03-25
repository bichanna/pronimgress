# pronimgress
Simple text progress bars in Nim!
```
Progress: [=================>          ] 62.3% Complete
```

## Usage
```nim
  # {prefix} {leftSurroundChar}{backgroundChar}{progressChar}{progressHeadChar}{rightSurroundChar} <percentage>% {suffix}
  # e.g., Progress: [=================>          ] 62.3% Complete
  # prefix            = "Progress:"
  # leftSurroundChar  = '['
  # backgroundChar    = ' '
  # progressChar      = '='
  # progressHeadChar  = '>'
  # rightSurroundChar = ']'
  # suffix            = "Complete"
```

```nim
import pronimgress

var progressBar = newPronimgressBar(
  prefix = "Doing something time consuming",
  leftSurroundChar = '[',
  rightSurroundChar = ']',
  backgroundChar = '-',
  progressChar = '=',
  progressHeadChar = '>',
  size = 100
)

for i in 0 ..< 101:
  # do something

  var msg = "Updating..."
  if i == 100:
    msg = "Complete"
  progressBar.update(1, msg)

stdout.write("\n")

# output: Doing something time consuming [===========================================================>] 100.0% Completed
```

## Contribution
Contribution is always welcome :)

## License 
[MIT](https://github.com/bichanna/pronimgress/blob/master/LICENSE)
