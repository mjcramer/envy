addSbtPlugin("net.virtual-void" % "sbt-dependency-graph" % "0.8.2")
addSbtPlugin("com.scalapenos" % "sbt-prompt" % "1.0.2")

promptTheme := PromptTheme(List(
  text("[SBT] (", fg(white)),
  gitBranch(clean = fg(green), dirty = fg(yellow)),
  text(") ", fg(white)),
  currentProject(fg(magenta)),
  text("> ", fg(white))
))

