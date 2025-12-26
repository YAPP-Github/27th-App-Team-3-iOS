import ProjectDescription
import ProjectDescriptionHelpers

let swiftlintScript = TargetScript.pre(
    script: """
    export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

    SWIFTLINT="$(command -v swiftlint || true)"
    if [ -z "$SWIFTLINT" ]; then
        echo "warning: SwiftLint not installed (skipping)"
        exit 0
    fi

    ROOT="$SRCROOT"
    while [ "$ROOT" != "/" ] && [ ! -f "$ROOT/.swiftlint.yml" ];   do
        ROOT="$(dirname "$ROOT")"
    done

    if [ ! -f "$ROOT/.swiftlint.yml" ]; then
        echo "warning: .swiftlint.yml not found (skipping)"
        exit 0
    fi

    echo "SwiftLint: $SWIFTLINT"
    echo "Config: $ROOT/.swiftlint.yml"

    "$SWIFTLINT" lint --config "$ROOT/.swiftlint.yml"
    """,
    name: "SwiftLint",
    basedOnDependencyAnalysis: false
)

let project = Project(
    name: Module.App.name,
    targets: [
        .app(
            implements: .iOS,
            config: .init(
                scripts: [swiftlintScript],
                settings: .settings(
                    base: [
                        "CODE_SIGN_STYLE": "Manual",
                        "DEVELOPMENT_TEAM": "VZC79KP79S",
                        "PROVISIONING_PROFILE_SPECIFIER": "match Development org.yapp.twix"
                    ]
                )
            )
        )
    ]
)
