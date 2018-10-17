
import SbtPrompt.autoImport._
import com.scalapenos.sbt.prompt._

// Adding this because idea isn't intellij-ent enough to understand ansi colors.
promptTheme := sys.props.get("idea.runid").fold {
  PromptTheme(
    List(
      text(" SBT ", fg(220).bg(93)),
      gitBranch(clean = fg(235).bg(190), dirty = fg(235).bg(214)).padLeft("  ").padRight(" "),
      currentProject(fg(16).bg(106)).pad(" "),
      text(" ", NoStyle)
    ),
    (previous, next) ⇒ StyledText("", fg(previous.style.background).bg(next.style.background))
  )
} { idea =>
  DefaultTheme
}
