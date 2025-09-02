import 'package:flutter/material.dart';
import '../../../core/models/models.dart';

class CreatorInfo extends StatelessWidget {
  final String creatorId;
  final String? creatorName;
  final String? creatorUsername;
  final String? creatorAvatarUrl;
  final bool isVerified;
  final VoidCallback? onTap;

  const CreatorInfo({
    super.key,
    required this.creatorId,
    this.creatorName,
    this.creatorUsername,
    this.creatorAvatarUrl,
    this.isVerified = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Creator Avatar
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: creatorAvatarUrl != null 
                    ? Colors.transparent 
                    : const Color(0xFF8B5CF6),
              ),
              child: creatorAvatarUrl != null
                  ? ClipOval(
                      child: Image.network(
                        creatorAvatarUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 16,
                          );
                        },
                      ),
                    )
                  : const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 16,
                    ),
            ),
            
            const SizedBox(width: 8),
            
            // Creator Name/Username
            Flexible(
              child: Text(
                creatorName ?? creatorUsername ?? 'Unknown Creator',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            
            // Verification Badge
            if (isVerified) ...[
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Color(0xFF8B5CF6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.verified,
                  color: Colors.white,
                  size: 10,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
