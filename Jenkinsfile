def resolveOwnerEmail(String configuredEmail) {
    String fromParam = configuredEmail?.trim()
    if (fromParam) {
        return fromParam
    }
    return env.CHANGE_AUTHOR_EMAIL?.trim() ?: env.GIT_AUTHOR_EMAIL?.trim() ?: ''
}

def notifyOwner(String ownerEmail, String message) {
    if (!ownerEmail?.trim()) {
        echo "Owner email is not configured. Skipping notification."
        return
    }

    mail(
        to: ownerEmail.trim(),
        subject: "[${env.JOB_NAME}] Dockerfile security pre-check failed",
        body: """${message}

Build URL: ${env.BUILD_URL}
"""
    )
}

pipeline {
    agent any

    parameters {
        string(
            name: 'DOCKERFILE_PATH',
            defaultValue: 'Dockerfile',
            description: 'Path to the Dockerfile to validate before build.'
        )
        string(
            name: 'OWNER_EMAIL',
            defaultValue: '',
            description: 'Owner email to notify when pre-check fails.'
        )
    }

    stages {
        stage('Dockerfile Security Pre-Check') {
            steps {
                script {
                    String dockerfilePath = params.DOCKERFILE_PATH?.trim() ?: 'Dockerfile'

                    if (!fileExists(dockerfilePath)) {
                        String message = "Dockerfile security pre-check failed: '${dockerfilePath}' was not found."
                        notifyOwner(params.OWNER_EMAIL, message)
                        error(message)
                    }

                    String dockerfileContent = readFile(file: dockerfilePath)
                    // Join Dockerfile line continuations to avoid false negatives for multiline RUN commands.
                    String normalizedContent = dockerfileContent.replaceAll(/\\\s*\r?\n\s*/, " ")

                    boolean hasUid1000UserCreation =
                        (normalizedContent =~ /(?im)^\s*RUN\s+.*\b(useradd|adduser)\b.*\b(--uid|-u)\s*=?\s*1000\b.*/).find() ||
                        (normalizedContent =~ /(?im)^\s*RUN\s+.*\b(--uid|-u)\s*=?\s*1000\b.*\b(useradd|adduser)\b.*/).find() ||
                        (normalizedContent =~ /(?im)^\s*RUN\s+.*:x:1000:1000:.*>>\s*\/etc\/passwd.*/).find()

                    boolean runsAsUser1000 =
                        (dockerfileContent =~ /(?im)^\s*USER\s+1000(?:\s*:\s*1000)?\s*$/).find()

                    List<String> violations = []
                    if (!hasUid1000UserCreation) {
                        violations.add("missing user creation with UID 1000")
                    }
                    if (!runsAsUser1000) {
                        violations.add("missing USER 1000 directive")
                    }

                    if (!violations.isEmpty()) {
                        String ownerEmail = resolveOwnerEmail(params.OWNER_EMAIL)
                        String message = """Dockerfile security pre-check failed for '${dockerfilePath}'.

Required best practices:
1) Create a user with UID 1000
2) Run container as USER 1000

Detected issues:
- ${violations.join('\n- ')}

Action required: fix the Dockerfile and push again."""

                        notifyOwner(ownerEmail, message)
                        error(message)
                    }

                    echo "Dockerfile security pre-check passed."
                }
            }
        }

        stage('Image Build') {
            steps {
                echo "Security checks passed. Continue with your existing docker build steps here."
            }
        }
    }
}
